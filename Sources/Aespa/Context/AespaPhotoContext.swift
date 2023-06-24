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
open class AespaPhotoContext {
    private let coreSession: AespaCoreSession
    private let albumManager: AespaCoreAlbumManager
    private let fileManager: AespaCoreFileManager
    private let option: AespaOption
    
    private let camera: AespaCoreCamera
    
    private var photoSetting: AVCapturePhotoSettings
    private let photoFileBufferSubject: CurrentValueSubject<Result<PhotoFile, Error>?, Never>
    
    init(
        coreSession: AespaCoreSession,
        camera: AespaCoreCamera,
        albumManager: AespaCoreAlbumManager,
        fileManager: AespaCoreFileManager,
        option: AespaOption
    ) {
        self.coreSession = coreSession
        self.camera = camera
        self.albumManager = albumManager
        self.fileManager = fileManager
        self.option = option
        
        self.photoSetting = AVCapturePhotoSettings()
        self.photoFileBufferSubject = .init(nil)
        
        // Add first video file to buffer if it exists
        if let firstPhotoFile = fileManager.fetchPhoto(
            albumName: option.asset.albumName,
            subDirectoryName: option.asset.photoDirectoryName,
            count: 1).first
        {
            photoFileBufferSubject.send(.success(firstPhotoFile))
        }
    }
}

extension AespaPhotoContext: PhotoContext {
    public var underlyingPhotoContext: AespaPhotoContext {
        self
    }
    
    public var photoFilePublisher: AnyPublisher<Result<PhotoFile, Error>, Never> {
        photoFileBufferSubject.handleEvents(receiveOutput: { status in
            if case .failure(let error) = status {
                Logger.log(error: error)
            }
        })
        .compactMap({ $0 })
        .eraseToAnyPublisher()
    }
    
    public var currentSetting: AVCapturePhotoSettings {
        photoSetting
    }
    
    public func capturePhotoWithError() async throws -> PhotoFile {
        let setting = AVCapturePhotoSettings(from: photoSetting)
        let rawPhotoAsset = try await camera.capture(setting: setting)
        
        guard let rawPhotoData = rawPhotoAsset.fileDataRepresentation() else {
            throw AespaError.file(reason: .unableToFlatten)
        }

        let filePath = try FilePathProvider.requestFilePath(
            from: fileManager.systemFileManager,
            directoryName: option.asset.albumName,
            subDirectoryName: option.asset.photoDirectoryName,
            fileName: option.asset.fileNameHandler())
        
        try fileManager.write(data: rawPhotoData, to: filePath)
        try await albumManager.addToAlbum(imageData: rawPhotoData)

        let photoFile = PhotoFileGenerator.generate(
            with: filePath,
            date: Date())
        
        photoFileBufferSubject.send(.success(photoFile))

        return photoFile
    }
    
    @discardableResult
    public func setFlashMode(to mode: AVCaptureDevice.FlashMode) -> AespaPhotoContext {
        photoSetting.flashMode = mode
        return self
    }
    
    @discardableResult
    public func redEyeReduction(enabled: Bool) -> AespaPhotoContext {
        photoSetting.isAutoRedEyeReductionEnabled = enabled
        return self
    }
    
    public func customize(_ setting: AVCapturePhotoSettings) {
        photoSetting = setting
    }
    
    public func fetchPhotoFiles(limit: Int) -> [PhotoFile] {
        return fileManager.fetchPhoto(
            albumName: option.asset.albumName,
            subDirectoryName: option.asset.photoDirectoryName,
            count: limit)
    }
}
