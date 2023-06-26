//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/24.
//

import UIKit
import Combine
import Foundation
import AVFoundation

///
public typealias ErrorHandler = (Error) -> Void

/// A protocol that defines the common behaviors and properties that all context types must implement.
///
/// It includes methods to control the quality, position, orientation, and auto-focusing behavior
/// of the session. It also includes the ability to adjust the zoom level of the session.
public protocol CommonContext {
    ///
    associatedtype CommonContextType: CommonContext & VideoContext & PhotoContext
    
    ///
    var underlyingCommonContext: CommonContextType { get }
    
    /// Sets the quality preset for the video recording session.
    ///
    /// - Parameter preset: An `AVCaptureSession.Preset` value indicating the quality preset to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func setQualityWithError(to preset: AVCaptureSession.Preset) throws -> CommonContextType
    
    /// Sets the camera position for the video recording session.
    ///
    /// It refers to `AespaOption.Session.cameraDevicePreference` when choosing the camera device.
    ///
    /// - Parameter position: An `AVCaptureDevice.Position` value indicating the camera position to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func setPositionWithError(to position: AVCaptureDevice.Position) throws -> CommonContextType
    
    /// Sets the orientation for the session.
    ///
    /// - Parameter orientation: An `AVCaptureVideoOrientation` value indicating the orientation to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    ///
    /// - Note: It sets the orientation of the video you are recording,
    ///     not the orientation of the `AVCaptureVideoPreviewLayer`.
    @discardableResult func setOrientationWithError(
        to orientation: AVCaptureVideoOrientation
    ) throws -> CommonContextType
    
    /// Sets the autofocusing mode for the video recording session.
    ///
    /// - Parameter mode: The focus mode(`AVCaptureDevice.FocusMode`) for the session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func setFocusWithError(
        mode: AVCaptureDevice.FocusMode, point: CGPoint?
    ) throws -> CommonContextType
    
    /// Sets the zoom factor for the video recording session.
    ///
    /// - Parameter factor: A `CGFloat` value indicating the zoom factor to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func zoomWithError(factor: CGFloat) throws -> CommonContextType
    
    /// This function provides a way to use a custom tuner to modify the current session.
    /// The tuner must conform to `AespaSessionTuning`.
    ///
    /// - Parameter tuner: An instance that conforms to `AespaSessionTuning`.
    /// - Throws: If the session fails to run the tuner.
    @discardableResult func customizeWithError<T: AespaSessionTuning>(_ tuner: T) throws -> CommonContextType
}

// MARK: Non-throwing methods
// These methods encapsulate error handling within the method itself rather than propagating it to the caller.
// This means any errors that occur during the execution of these methods will be caught and logged, not thrown.
// Although it simplifies error handling, this approach may not be recommended
// because it offers less control to callers.
// Developers are encouraged to use methods that throw errors, to gain finer control over error handling.
extension CommonContext {
    /// Sets the quality preset for the video recording session.
    ///
    /// - Parameter preset: An `AVCaptureSession.Preset` value indicating the quality preset to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setQuality(
        to preset: AVCaptureSession.Preset,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.setQualityWithError(to: preset)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
    
    /// Sets the camera position for the video recording session.
    ///
    /// - Parameter position: An `AVCaptureDevice.Position` value indicating the camera position to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setPosition(
        to position: AVCaptureDevice.Position,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.setPositionWithError(to: position)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
    
    /// Sets the orientation for the session.
    ///
    /// - Parameter orientation: An `AVCaptureVideoOrientation` value indicating the orientation to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Note: It sets the orientation of the video you are recording,
    /// not the orientation of the `AVCaptureVideoPreviewLayer`.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setOrientation(
        to orientation: AVCaptureVideoOrientation,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.setOrientationWithError(to: orientation)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
    
    /// Sets the autofocusing mode for the video recording session.
    ///
    /// - Parameter mode: The focus mode for the capture device.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setFocus(
        mode: AVCaptureDevice.FocusMode,
        point: CGPoint? = nil,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.setFocusWithError(mode: mode, point: point)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
    
    /// Sets the zoom factor for the video recording session.
    ///
    /// - Parameter factor: A `CGFloat` value indicating the zoom factor to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func zoom(
        factor: CGFloat,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.zoomWithError(factor: factor)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
    
    @discardableResult
    public func custom<T: AespaSessionTuning>(
        _ tuner: T,
        errorHandler: ErrorHandler? = nil
    ) -> CommonContextType {
        do {
            return try self.customizeWithError(tuner)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingCommonContext
    }
}

/// A protocol that defines the behaviors and properties specific to the video context.
///
/// It adds video-specific capabilities such as checking if
/// the session is currently recording or muted, and controlling video recording,
/// stabilization, torch mode, and fetching recorded video files.
public protocol VideoContext {
    ///
    associatedtype VideoContextType: VideoContext
    ///
    var underlyingVideoContext: VideoContextType { get }
    
    /// A Boolean value that indicates whether the session is currently recording video.
    var isRecording: Bool { get }

    /// This publisher is responsible for emitting `VideoFile` objects resulting from completed recordings.
    ///
    /// In the case of an error, it logs the error before forwarding it wrapped in a `Result.failure`.
    /// If you don't want to show logs, set `enableLogging` to `false` from `AespaOption.Log`
    ///
    /// - Returns: `VideoFile` wrapped in a `Result` type.
    var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> { get }
        
    /// This property reflects the current state of audio input.
    ///
    /// If it returns `true`, the audio input is currently muted.
    var isMuted: Bool { get }
    
    /// - Throws: `AespaError` if the video file path request fails,
    ///     orientation setting fails, or starting the recording fails.
    ///
    /// - Note: If `autoVideoOrientation` option is enabled,
    ///     it sets the orientation according to the current device orientation.
    func startRecordingWithError() throws
    
    /// Stops the ongoing video recording session and attempts to add the video file to the album.
    ///
    /// Supporting `async`, you can use this method in Swift Concurrency's context
    ///
    /// - Throws: `AespaError` if stopping the recording fails.
    @discardableResult func stopRecordingWithError() async throws -> VideoFile
    
    /// Mutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func muteWithError() throws -> VideoContextType
    
    /// Unmutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func unmuteWithError() throws -> VideoContextType
    
    /// Sets the stabilization mode for the video recording session.
    ///
    /// - Parameter mode: An `AVCaptureVideoStabilizationMode` value
    ///     indicating the stabilization mode to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> VideoContextType
    
    /// Sets the torch mode and level for the video recording session.
    ///
    /// - Parameters:
    ///     - mode: The desired torch mode (AVCaptureDevice.TorchMode).
    ///     - level: The desired torch level as a Float between 0.0 and 1.0.
    ///
    /// - Returns: Returns self, allowing additional settings to be configured.
    ///
    /// - Throws: Throws an error if setting the torch mode or level fails.
    ///
    /// - Note: This function might throw an error if the torch mode is not supported,
    ///     or the specified level is not within the acceptable range.
    @discardableResult func setTorchWithError(mode: AVCaptureDevice.TorchMode, level: Float) throws -> VideoContextType
    
    /// Fetches a list of recorded video files.
    /// The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of video files to fetch.
    ///
    /// - Returns: An array of `VideoFile` instances.
    func fetchVideoFiles(limit: Int) -> [VideoFile]
}

// MARK: Non-throwing methods
// These methods encapsulate error handling within the method itself rather than propagating it to the caller.
// This means any errors that occur during the execution of these methods will be caught and logged, not thrown.
// Although it simplifies error handling, this approach may not be recommended
// because it offers less control to callers.
// Developers are encouraged to use methods that throw errors, to gain finer control over error handling.
extension VideoContext {
    /// Starts the recording of a video session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Note: If auto video orientation is enabled,
    ///     it sets the orientation according to the current device orientation.
    public func startRecording(errorHandler: ErrorHandler? = nil) {
        do {
            try startRecordingWithError()
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
    }
    
    /// Stops the current video recording session and attempts to save the video file to the album.
    ///
    /// Any errors that occur during the process are captured and logged.
    ///
    /// - Parameter completionHandler: A closure that handles the result of the operation.
    ///      It's called with a `Result` object that encapsulates either a `VideoFile` instance.
    ///
    /// - Note: It is recommended to use the ``stopRecording() async throws``
    /// for more straightforward error handling.
    public func stopRecording(
        _ completionHandler: @escaping (Result<VideoFile, Error>) -> Void = { _ in }
    ) {
        Task(priority: .utility) {
            do {
                let videoFile = try await self.stopRecordingWithError()
                return completionHandler(.success(videoFile))
            } catch let error {
                Logger.log(error: error)
                return completionHandler(.failure(error))
            }
        }
    }
    
    /// Mutes the audio input for the video recording session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func mute(errorHandler: ErrorHandler? = nil) -> VideoContextType {
        do {
            return try self.muteWithError()
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingVideoContext
    }
    
    /// Unmutes the audio input for the video recording session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func unmute(errorHandler: ErrorHandler? = nil) -> VideoContextType {
        do {
            return try self.unmuteWithError()
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation

            return underlyingVideoContext
        }
    }
    
    /// Sets the stabilization mode for the video recording session.
    ///
    /// - Parameter mode: An `AVCaptureVideoStabilizationMode` value
    ///     indicating the stabilization mode to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setStabilization(
        mode: AVCaptureVideoStabilizationMode,
        errorHandler: ErrorHandler? = nil
    ) -> VideoContextType {
        do {
            return try self.setStabilizationWithError(mode: mode)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return underlyingVideoContext
    }
    
    /// Sets the torch mode and level for the video recording session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Parameters:
    ///     - mode: The desired torch mode (AVCaptureDevice.TorchMode).
    ///     - level: The desired torch level as a Float between 0.0 and 1.0.
    ///
    /// - Returns: Returns self, allowing additional settings to be configured.
    ///
    /// - Note: This function might throw an error if the torch mode is not supported,
    ///     or the specified level is not within the acceptable range.
    @discardableResult
    public func setTorch(
        mode: AVCaptureDevice.TorchMode,
        level: Float,
        errorHandler: ErrorHandler? = nil
    ) -> VideoContextType {
        do {
            return try self.setTorchWithError(mode: mode, level: level)
        } catch let error {
            errorHandler?(error)
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return underlyingVideoContext
    }

    /// Fetches a list of recorded video files.
    /// The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of video files to fetch.
    ///     If the limit is set to 0 (default), all recorded video files will be fetched.
    /// - Returns: An array of `VideoFile` instances.
    public func fetchVideoFiles(limit: Int = 0) -> [VideoFile] {
        fetchVideoFiles(limit: limit)
    }
}

/// A protocol that defines the behaviors and properties specific to the photo context.
///
/// It adds photo-specific capabilities such as accessing
/// current photo settings, controlling flash mode, and red-eye reduction, capturing
/// photo, and fetching captured photo files.
public protocol PhotoContext {
    associatedtype PhotoContextType: PhotoContext
    
    var underlyingPhotoContext: PhotoContextType { get }
    
    /// The publisher that broadcasts the result of a photo file operation.
    /// It emits a `Result` object containing a `PhotoFile` on success or an `Error` on failure,
    /// and never fails itself. This can be used to observe the photo capturing process and handle
    /// the results asynchronously.
    var photoFilePublisher: AnyPublisher<Result<PhotoFile, Error>, Never> { get }
    
    /// A variable holding current `AVCapturePhotoSettings`
    var currentSetting: AVCapturePhotoSettings { get }
    
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
    @discardableResult func capturePhotoWithError() async throws -> PhotoFile
    
    /// Sets the flash mode for the camera and returns the updated `AespaPhotoContext` instance.
    /// The returned instance can be used for chaining configuration.
    ///
    /// - Parameter mode: The `AVCaptureDevice.FlashMode` to set for the camera.
    /// - Returns: The updated `AespaPhotoContext` instance.
    @discardableResult func setFlashMode(to mode: AVCaptureDevice.FlashMode) -> PhotoContextType
    
    /// Sets the red eye reduction mode for the camera and returns the updated `AespaPhotoContext` instance.
    /// The returned instance can be used for chaining configuration.
    ///
    /// - Parameter enabled: A boolean indicating whether the red eye reduction should be enabled or not.
    /// - Returns: The updated `AespaPhotoContext` instance.
    @discardableResult func redEyeReduction(enabled: Bool) -> PhotoContextType
    
    /// Updates the photo capturing settings for the `AespaPhotoContext` instance.
    ///
    /// - Note: This method can be potentially risky to use, as it overrides the existing capture settings.
    ///  Not all `AVCapturePhotoSettings` are supported, for instance, live photos are not supported.
    ///  It's recommended to understand the implications of the settings before applying them.
    ///
    /// - Parameter setting: The `AVCapturePhotoSettings` to use for photo capturing.
    func custom(_ setting: AVCapturePhotoSettings) -> PhotoContextType
    
    // MARK: - Utilities
    /// Fetches a list of captured photo files.
    /// The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of files to fetch.
    ///
    /// - Returns: An array of `PhotoFile` instances.
    func fetchPhotoFiles(limit: Int) -> [PhotoFile]
}

// MARK: Non-throwing methods
// These methods encapsulate error handling within the method itself rather than propagating it to the caller.
// This means any errors that occur during the execution of these methods will be caught and logged, not thrown.
// Although it simplifies error handling, this approach may not be recommended because
// it offers less control to callers.
// Developers are encouraged to use methods that throw errors, to gain finer control over error handling.
extension PhotoContext {
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
                let photoFile = try await self.capturePhotoWithError()
                return completionHandler(.success(photoFile))
            } catch let error {
                Logger.log(error: error)
                return completionHandler(.failure(error))
            }
        }
    }
    
    /// Fetches a list of captured photo files.
    /// The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of files to fetch.
    ///     If the limit is set to 0 (default), all recorded video files will be fetched.
    /// - Returns: An array of `PhotoFile` instances.
    public func fetchPhotoFiles(limit: Int = 0) -> [PhotoFile] {
        fetchPhotoFiles(limit: limit)
    }
}
