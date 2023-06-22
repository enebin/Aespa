//
//  AespaPhotoContext.swift
//  
//
//  Created by 이영빈 on 2023/06/22.
//

import Combine
import Foundation
import AVFoundation

open class AespaPhotoContext {
    private let coreSession: AespaCoreSession
    private let camera: AespaCoreCamera
    private let albumManager: AespaCoreAlbumManager
    private let fileManager: AespaCoreFileManager
    private let option: AespaOption
    
    private var capturePhotoSetting: AVCapturePhotoSettings
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
    
    /// Asynchronously captures a photo using the specified `AVCapturePhotoSettings`.
    ///
    /// This function utilizes the `captureWithError(setting:)` function to perform the actual photo capture,
    /// while handling any errors that may occur. If the photo capture is successful, it will return a `PhotoFile`
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

        try await albumManager.addToAlbum(imageData: rawPhotoData)

        let photoFile = PhotoFileGenerator.generate(data: rawPhotoData, date: Date())
        photoFileBufferSubject.send(.success(photoFile))

        return photoFile
    }

}
