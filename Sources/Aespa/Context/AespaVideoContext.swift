//
//  AespaVideoContext.swift
//  
//
//  Created by 이영빈 on 2023/06/22.
//

import UIKit

import Combine
import Foundation
import AVFoundation

/// `AespaVideoContext` is an open class that provides a context for video recording operations.
/// It has methods and properties to handle the video recording and settings.
open class AespaVideoContext {
    private let coreSession: AespaCoreSession
    private let recorder: AespaCoreRecorder
    private let albumManager: AespaCoreAlbumManager
    private let fileManager: AespaCoreFileManager
    private let option: AespaOption
    
    private let videoFileBufferSubject: CurrentValueSubject<Result<VideoFile, Error>?, Never>

    private(set) var isRecording: Bool

    init(
        coreSession: AespaCoreSession,
        recorder: AespaCoreRecorder,
        albumManager: AespaCoreAlbumManager,
        fileManager: AespaCoreFileManager,
        option: AespaOption
    ) {
        self.coreSession = coreSession
        self.recorder = recorder
        self.albumManager = albumManager
        self.fileManager = fileManager
        self.option = option
        
        self.videoFileBufferSubject = .init(nil)

        self.isRecording = false
        
        // Add first video file to buffer if it exists
        if let firstVideoFile = fileManager.fetch(albumName: option.asset.albumName, count: 1).first {
            videoFileBufferSubject.send(.success(firstVideoFile))
        }
    }
    
    /// This property reflects the current state of audio input.
    ///
    /// If it returns `true`, the audio input is currently muted.
    public var isMuted: Bool {
        coreSession.audioDeviceInput == nil
    }
    
    /// This publisher is responsible for emitting `VideoFile` objects resulting from completed recordings.
    ///
    /// In the case of an error, it logs the error before forwarding it wrapped in a `Result.failure`.
    /// If you don't want to show logs, set `enableLogging` to `false` from `AespaOption.Log`
    ///
    /// - Returns: `VideoFile` wrapped in a `Result` type.
    public var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        videoFileBufferSubject.handleEvents(receiveOutput: { status in
            if case .failure(let error) = status {
                Logger.log(error: error)
            }
        })
        .compactMap({ $0 })
        .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    // MARK: No throws for convenience - not recommended!
    /// Starts the recording of a video session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Note: If auto video orientation is enabled,
    ///     it sets the orientation according to the current device orientation.
    public func startRecording() {
        do {
            try startRecordingWithError()
        } catch let error {
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
    public func mute() -> AespaVideoContext {
        do {
            try self.muteWithError()
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Unmutes the audio input for the video recording session.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func unmute() -> AespaVideoContext {
        do {
            try self.unmuteWithError()
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Sets the quality preset for the video recording session.
    ///
    /// - Parameter preset: An `AVCaptureSession.Preset` value indicating the quality preset to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setQuality(to preset: AVCaptureSession.Preset) -> AespaVideoContext {
        do {
            try self.setQualityWithError(to: preset)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Sets the camera position for the video recording session.
    ///
    /// - Parameter position: An `AVCaptureDevice.Position` value indicating the camera position to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setPosition(to position: AVCaptureDevice.Position) -> AespaVideoContext {
        do {
            try self.setPositionWithError(to: position)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Sets the orientation for the video recording session.
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
    public func setOrientation(to orientation: AVCaptureVideoOrientation) -> AespaVideoContext {
        do {
            try self.setOrientationWithError(to: orientation)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
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
    public func setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaVideoContext {
        do {
            try self.setStabilizationWithError(mode: mode)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Sets the autofocusing mode for the video recording session.
    ///
    /// - Parameter mode: The focus mode for the capture device.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaVideoContext {
        do {
            try self.setAutofocusingWithError(mode: mode)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    /// Sets the zoom factor for the video recording session.
    ///
    /// - Parameter factor: A `CGFloat` value indicating the zoom factor to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func zoom(factor: CGFloat) -> AespaVideoContext {
        do {
            try self.zoomWithError(factor: factor)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
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
    public func setTorch(mode: AVCaptureDevice.TorchMode, level: Float) -> AespaVideoContext {
        do {
            try self.setTorchWitherror(mode: mode, level: level)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }

        return self
    }

    // MARK: - Throwing/// Starts the recording of a video session.
    ///
    /// - Throws: `AespaError` if the video file path request fails,
    ///     orientation setting fails, or starting the recording fails.
    ///
    /// - Note: If `autoVideoOrientation` option is enabled,
    ///     it sets the orientation according to the current device orientation.
    public func startRecordingWithError() throws {
        let fileName = option.asset.fileNameHandler()
        let filePath = try VideoFilePathProvider.requestFilePath(
            from: fileManager.systemFileManager,
            directoryName: option.asset.albumName,
            fileName: fileName,
            extension: "mp4")

        if option.session.autoVideoOrientationEnabled {
            try setOrientationWithError(to: UIDevice.current.orientation.toVideoOrientation)
        }

        try recorder.startRecording(in: filePath)
    }

    /// Stops the ongoing video recording session and attempts to add the video file to the album.
    ///
    /// Supporting `async`, you can use this method in Swift Concurrency's context
    ///
    /// - Throws: `AespaError` if stopping the recording fails.
    public func stopRecordingWithError() async throws -> VideoFile {
        let videoFilePath = try await recorder.stopRecording()
        let videoFile = VideoFileGenerator.generate(with: videoFilePath, date: Date())

        try await albumManager.addToAlbum(filePath: videoFilePath)
        videoFileBufferSubject.send(.success(videoFile))

        return videoFile
    }

    /// Mutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func muteWithError() throws -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: true)
        try coreSession.run(tuner)
        return self
    }

    /// Unmutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func unmuteWithError() throws -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: false)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the quality preset for the video recording session.
    ///
    /// - Parameter preset: An `AVCaptureSession.Preset` value indicating the quality preset to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setQualityWithError(to preset: AVCaptureSession.Preset) throws -> AespaVideoContext {
        let tuner = QualityTuner(videoQuality: preset)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the camera position for the video recording session.
    ///
    /// It refers to `AespaOption.Session.cameraDevicePreference` when choosing the camera device.
    ///
    /// - Parameter position: An `AVCaptureDevice.Position` value indicating the camera position to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setPositionWithError(to position: AVCaptureDevice.Position) throws -> AespaVideoContext {
        let tuner = CameraPositionTuner(position: position,
                                        devicePreference: option.session.cameraDevicePreference)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the orientation for the video recording session.
    ///
    /// - Parameter orientation: An `AVCaptureVideoOrientation` value indicating the orientation to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    ///
    /// - Note: It sets the orientation of the video you are recording,
    /// not the orientation of the `AVCaptureVideoPreviewLayer`.
    @discardableResult
    public func setOrientationWithError(to orientation: AVCaptureVideoOrientation) throws -> AespaVideoContext {
        let tuner = VideoOrientationTuner(orientation: orientation)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the stabilization mode for the video recording session.
    ///
    /// - Parameter mode: An `AVCaptureVideoStabilizationMode` value
    ///     indicating the stabilization mode to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaVideoContext {
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the autofocusing mode for the video recording session.
    ///
    /// - Parameter mode: The focus mode(`AVCaptureDevice.FocusMode`) for the session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaVideoContext {
        let tuner = AutoFocusTuner(mode: mode)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the zoom factor for the video recording session.
    ///
    /// - Parameter factor: A `CGFloat` value indicating the zoom factor to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaVideoContext`, for chaining calls.
    @discardableResult
    public func zoomWithError(factor: CGFloat) throws -> AespaVideoContext {
        let tuner = ZoomTuner(zoomFactor: factor)
        try coreSession.run(tuner)
        return self
    }

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
    @discardableResult
    public func setTorchWitherror(mode: AVCaptureDevice.TorchMode, level: Float) throws -> AespaVideoContext {
        let tuner = TorchTuner(level: level, torchMode: mode)
        try coreSession.run(tuner)
        return self
    }

    // MARK: - Customizable
    /// This function provides a way to use a custom tuner to modify the current session.
    /// The tuner must conform to `AespaSessionTuning`.
    ///
    /// - Parameter tuner: An instance that conforms to `AespaSessionTuning`.
    /// - Throws: If the session fails to run the tuner.
    public func customize<T: AespaSessionTuning>(_ tuner: T) throws {
        try coreSession.run(tuner)
    }
}
