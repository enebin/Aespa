//
//  AespaPhotoContext.swift
//  
//
//  Created by 이영빈 on 2023/06/22.
//

import Combine
import Foundation
import AVFoundation

/// `AespaPhotoContext` is an open class that provides a context for photo capturing operations.
/// It has methods and properties to handle the photo capturing and settings.
nonisolated open class AespaPhotoContext: @unchecked Sendable {
    private let coreSession: AespaCoreSession
    private let albumManager: AespaCoreAlbumManager
    private let option: AespaOption
    
    private let camera: AespaCoreCamera
    private let settingLock = NSRecursiveLock()
    
    private var photoSetting: AVCapturePhotoSettings
    private let photoFileBufferSubject: CurrentValueSubject<Result<PhotoFile, Error>?, Never>
    
    init(
        coreSession: AespaCoreSession,
        camera: AespaCoreCamera,
        albumManager: AespaCoreAlbumManager,
        option: AespaOption
    ) {
        self.coreSession = coreSession
        self.camera = camera
        self.albumManager = albumManager
        self.option = option
        
        self.photoSetting = AVCapturePhotoSettings()
        self.photoFileBufferSubject = .init(nil)
        
        // Add first video file to buffer if it exists
        if option.asset.synchronizeWithLocalAlbum {
            Task(priority: .utility) {
                guard let firstPhotoAsset = await albumManager.fetchPhotoFile(limit: 1).first else {
                    return
                }
                
                photoFileBufferSubject.sendOnMainThread(.success(firstPhotoAsset.toPhotoFile))
            }
        }
    }
}

nonisolated private extension AespaPhotoContext {
    func withSettingLock<T>(_ work: () throws -> T) rethrows -> T {
        settingLock.lock()
        defer { settingLock.unlock() }
        return try work()
    }
}

nonisolated extension AespaPhotoContext: PhotoContext {
    public var underlyingPhotoContext: AespaPhotoContext {
        self
    }
    
    public var photoFilePublisher: AnyPublisher<Result<PhotoFile, Error>, Never> {
        photoFileBufferSubject
            .compactMap({ $0 })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { status in
                if case .failure(let error) = status {
                    Logger.log(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
    
    public var currentSetting: AVCapturePhotoSettings {
        withSettingLock {
            AVCapturePhotoSettings(from: photoSetting)
        }
    }
    
    public func capturePhoto(
        autoVideoOrientationEnabled: Bool = false,
        _ completionHandler: @escaping ResultHandler<PhotoFile>
    ) {
        Task(priority: .utility) {
            do {
                let photoFile = try await self.capturePhotoWithError(autoVideoOrientationEnabled: autoVideoOrientationEnabled)
                completionHandler(.success(photoFile))
            } catch let error {
                Logger.log(error: error)
                completionHandler(.failure(error))
            }
        }
    }
    
    @discardableResult
    public func photo(
        _ photoContextOption: PhotoContextOption,
        onComplete: CompletionHandler? = nil
    ) -> AespaPhotoContext {
        let onComplete = onComplete ?? { _ in }
        
        switch photoContextOption {
        case .flashMode(let flashMode):
            withSettingLock {
                photoSetting.flashMode = flashMode
            }
        case .redEyeReduction(let enabled):
            withSettingLock {
                photoSetting.isAutoRedEyeReductionEnabled = enabled
            }
        case .custom(let aVCapturePhotoSettings):
            withSettingLock {
                photoSetting = aVCapturePhotoSettings
            }
        }
        
        onComplete(.success(()))
        return self
    }
    
    public func fetchPhotoFiles(limit: Int) async -> [PhotoAsset] {
        guard option.asset.synchronizeWithLocalAlbum else {
            Logger.log(
                message:
                    "'option.asset.synchronizeWithLocalAlbum' is set to false " +
                    "so no photos will be fetched from the local album. " +
                    "If you intended to fetch photos, " +
                    "please ensure 'option.asset.synchronizeWithLocalAlbum' is set to true."
            )
            return []
        }
        
        return await albumManager.fetchPhotoFile(limit: limit)
    }
}

nonisolated private extension AespaPhotoContext {
    func capturePhotoWithError(autoVideoOrientationEnabled: Bool) async throws -> PhotoFile {
        let setting = withSettingLock {
            AVCapturePhotoSettings(from: photoSetting)
        }
        let capturePhoto = try await camera.capture(setting: setting, autoVideoOrientationEnabled: autoVideoOrientationEnabled)
        
        guard let rawPhotoData = capturePhoto.fileDataRepresentation() else {
            throw AespaError.file(reason: .unableToFlatten)
        }
        
        if option.asset.synchronizeWithLocalAlbum {
            // Register to album
            try await albumManager.addToAlbum(imageData: rawPhotoData)
        }
        
        let photoFile = PhotoFileGenerator.generate(
            data: rawPhotoData,
            date: Date())
        
        photoFileBufferSubject.sendOnMainThread(.success(photoFile))
        return photoFile
    }
}

// MARK: - Deprecated methods
nonisolated extension AespaPhotoContext {
    @available(*, deprecated, message: "Please use `photo` instead.")
    @discardableResult
    public func flashMode(to mode: AVCaptureDevice.FlashMode) -> AespaPhotoContext {
        withSettingLock {
            photoSetting.flashMode = mode
        }
        return self
    }
    
    @available(*, deprecated, message: "Please use `photo` instead.")
    @discardableResult
    public func redEyeReduction(enabled: Bool) -> AespaPhotoContext {
        withSettingLock {
            photoSetting.isAutoRedEyeReductionEnabled = enabled
        }
        return self
    }
    
    @available(*, deprecated, message: "Please use `photo` instead.")
    public func custom(_ setting: AVCapturePhotoSettings) -> AespaPhotoContext {
        withSettingLock {
            photoSetting = setting
        }
        return self
    }
}
