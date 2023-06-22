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
    private let camera: AespaCoreCamera
    private let albumManager: AespaCoreAlbumManager
    private let fileManager: AespaCoreFileManager
    private let option: AespaOption
    
    private(set) var capturePhotoSetting: AVCapturePhotoSettings
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
        
        self.capturePhotoSetting = .init()
        self.photoFileBufferSubject = .init(nil)
    }
    
    // MARK: Computed variables
    /// The publisher that broadcasts the result of a photo file operation.
    /// It emits a `Result` object containing a `PhotoFile` on success or an `Error` on failure,
    /// and never fails itself. This can be used to observe the photo capturing process and handle
    /// the results asynchronously.
    public var photoFilePublisher: AnyPublisher<Result<PhotoFile, Error>, Never> {
        photoFileBufferSubject.handleEvents(receiveOutput: { status in
            if case .failure(let error) = status {
                Logger.log(error: error)
            }
        })
        .compactMap({ $0 })
        .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    /// Asynchronously captures a photo using the specified `AVCapturePhotoSettings`.
    ///
    /// If the photo capture is successful, it will return a `PhotoFile`
    /// object through the provided completion handler.
    ///
    /// In case of an error during the photo capture process, the error will be logged and also returned via
    /// the completion handler.
    ///
    /// - Parameters:
    ///   - completionHandler: A closure to be invoked once the photo capture process is completed. This
    ///     closure takes a `Result` type where `Success` contains a `PhotoFile` object and
    ///     `Failure` contains an `Error` object. By default, the closure does nothing.
    ///
    public func capturePhoto(
        _ completionHandler: @escaping (Result<PhotoFile, Error>) -> Void = { _ in }
    ) {
        Task(priority: .utility) {
            do {
                let photoFile = try await self.captureWithError()
                return completionHandler(.success(photoFile))
            } catch let error {
                Logger.log(error: error)
                return completionHandler(.failure(error))
            }
        }
    }
    
    /// Sets the flash mode for the camera and returns the updated `AespaPhotoContext` instance.
    /// The returned instance can be used for chaining configuration.
    ///
    /// - Parameter mode: The `AVCaptureDevice.FlashMode` to set for the camera.
    /// - Returns: The updated `AespaPhotoContext` instance.
    public func setFlashMode(to mode: AVCaptureDevice.FlashMode) -> AespaPhotoContext {
        capturePhotoSetting.flashMode = mode
        return self
    }
    
    /// Sets the red eye reduction mode for the camera and returns the updated `AespaPhotoContext` instance.
    /// The returned instance can be used for chaining configuration.
    ///
    /// - Parameter enabled: A boolean indicating whether the red eye reduction should be enabled or not.
    /// - Returns: The updated `AespaPhotoContext` instance.
    public func redeyeReduction(enabled: Bool) -> AespaPhotoContext {
        capturePhotoSetting.isAutoRedEyeReductionEnabled = enabled
        return self
    }

    // MARK: - Throwing
    /// Asynchronously captures a photo with the specified `AVCapturePhotoSettings`.
    ///
    /// The captured photo is flattened into a `Data` object, and then added to an album. A `PhotoFile`
    /// object is then created using the raw photo data and the current date. This `PhotoFile` is sent
    /// through the `photoFileBufferSubject` and then returned to the caller.
    ///
    /// If any part of this process fails, an `AespaError` is thrown.
    ///
    /// - Returns: A `PhotoFile` object representing the captured photo.
    /// - Throws: An `AespaError` if there is an issue capturing the photo,
    ///     flattening it into a `Data` object, or adding it to the album.
    public func captureWithError() async throws -> PhotoFile {
        let rawPhotoAsset = try await camera.capture(setting: self.capturePhotoSetting)
        
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
    
    /// Updates the photo capturing settings for the `AespaPhotoContext` instance.
    ///
    /// - Note: This method can be potentially risky to use, as it overrides the existing capture settings.
    ///  Not all `AVCapturePhotoSettings` are supported, for instance, live photos are not supported.
    ///  It's recommended to understand the implications of the settings before applying them.
    ///
    /// - Parameter setting: The `AVCapturePhotoSettings` to use for photo capturing.
    public func customize(_ setting: AVCapturePhotoSettings) {
        capturePhotoSetting = setting
    }
}
