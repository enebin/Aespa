//
//  AespaSession.swift
//  
//
//  Created by Young Bin on 2023/06/03.
//

import UIKit
import Combine
import Foundation
import AVFoundation

/// The `AespaSession` is a Swift interface which provides a wrapper around the `AVFoundation`'s `AVCaptureSession`,
/// simplifying its use for video capture.
///
/// The interface allows you to start and stop recording, manage device input and output,
/// change video quality and camera's position, etc.
/// For more option, you can use customization method to handle session with your own logic.
///
/// It also includes functionalities to fetch video files.
open class AespaSession {
    private let option: AespaOption
    private let coreSession: AespaCoreSession
    private let recorder: AespaCoreRecorder
    private let fileManager: FileManager
    private let albumManager: AespaCoreAlbumManager
    
    private let videoFileBufferSubject: CurrentValueSubject<Result<VideoFile, Error>?, Never>
    private let previewLayerSubject: CurrentValueSubject<AVCaptureVideoPreviewLayer?, Never>
    
    /// A `UIKit` layer that you use to display video as it is being captured by an input device.
    ///
    /// - Note: If you're looking for a `View` for `SwiftUI`, use `preview`
    public let previewLayer: AVCaptureVideoPreviewLayer

    convenience init(option: AespaOption) {
        let session = AespaCoreSession(option: option)
        
        self.init(
            option: option,
            session: session,
            recorder: .init(core: session),
            fileManager: .default,
            albumManager: .init(albumName: option.asset.albumName)
        )
    }
    
    init(
        option: AespaOption,
        session: AespaCoreSession,
        recorder: AespaCoreRecorder,
        fileManager: FileManager,
        albumManager: AespaCoreAlbumManager
    ) {
        self.option = option
        self.coreSession = session
        self.recorder = recorder
        self.fileManager = fileManager
        self.albumManager = albumManager
        
        self.videoFileBufferSubject = .init(nil)
        self.previewLayerSubject = .init(nil)
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        // Add first video file to buffer if it exists
        if let firstVideoFile = fetch(count: 1).first {
            self.videoFileBufferSubject.send(.success(firstVideoFile))
        }
    }
    
    // MARK: - vars
    /// This property exposes the underlying `AVCaptureSession` that `Aespa` currently utilizes.
    ///
    /// While you can directly interact with this object, it is strongly recommended to avoid modifications
    /// that could yield unpredictable behavior.
    /// If you require custom configurations, consider utilizing the `custom` function we offer whenever possible.
    public var captureSession: AVCaptureSession {
        return coreSession
    }

    /// This property reflects the current state of audio input.
    ///
    /// If it returns `true`, the audio input is currently muted.
    public var isMuted: Bool {
        coreSession.audioDeviceInput == nil
    }

    /// This property provides the maximum zoom factor supported by the active video device format.
    public var maxZoomFactor: CGFloat? {
        guard let videoDeviceInput = coreSession.videoDeviceInput else { return nil }
        return videoDeviceInput.device.activeFormat.videoMaxZoomFactor
    }

    /// This property reflects the current zoom factor applied to the video device.
    public var currentZoomFactor: CGFloat? {
        guard let videoDeviceInput = coreSession.videoDeviceInput else { return nil }
        return videoDeviceInput.device.videoZoomFactor
    }

    /// This publisher is responsible for emitting `VideoFile` objects resulting from completed recordings.
    ///
    /// In the case of an error, it logs the error before forwarding it wrapped in a `Result.failure`.
    /// If you don't want to show logs, set `enableLogging` to `false` from `AespaOption.Log`
    ///
    /// - Returns: `VideoFile` wrapped in a `Result` type.
    public var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        recorder.fileIOResultPublihser.map { status in
            switch status {
            case .success(let url):
                return .success(VideoFileGenerator.generate(with: url))
            case .failure(let error):
                Logger.log(error: error)
                return .failure(error)
            }
        }
        .merge(with: videoFileBufferSubject.eraseToAnyPublisher())
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }

    /// This publisher is responsible for emitting updates to the preview layer.
    ///
    /// A log message is printed to the console every time a new layer is pushed.
    /// If you don't want to show logs, set `enableLogging` to `false` from `AespaOption.Log`
    public var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        previewLayerSubject.handleEvents(receiveOutput: { _ in
            Logger.log(message: "Preview layer is updated")
        })
        .compactMap { $0 }
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
    /// - Note: It is recommended to use the ``stopRecording() async throws`` for more straightforward error handling.
    public func stopRecording(
        _ completionHandler: @escaping (Result<VideoFile, Error>) -> Void = { _ in }
    ) {
        Task(priority: .utility) {
            do {
                let videoFile = try await self.stopRecording()
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func mute() -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func unmute() -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setQuality(to preset: AVCaptureSession.Preset) -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setPosition(to position: AVCaptureDevice.Position) -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setOrientation(to orientation: AVCaptureVideoOrientation) -> AespaSession {
        do {
            try self.setOrientationWithError(to: orientation)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return self
    }

    /// Sets the stabilization mode for the video recording session.
    ///
    /// - Parameter mode: An `AVCaptureVideoStabilizationMode` value indicating the stabilization mode to be set.
    ///
    /// If an error occurs during the operation, the error is logged.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setStabilization(mode: AVCaptureVideoStabilizationMode) -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setAutofocusing(mode: AVCaptureDevice.FocusMode) -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func zoom(factor: CGFloat) -> AespaSession {
        do {
            try self.zoomWithError(factor: factor)
        } catch let error {
            Logger.log(error: error) // Logs any errors encountered during the operation
        }
        
        return self
    }

    // MARK: - Throwing/// Starts the recording of a video session.
    ///
    /// - Throws: `AespaError` if the video file path request fails, orientation setting fails, or starting the recording fails.
    ///
    /// - Note: If `autoVideoOrientation` option is enabled,
    ///     it sets the orientation according to the current device orientation.
    public func startRecordingWithError() throws {
        let fileName = option.asset.fileNameHandler()
        let filePath = try VideoFilePathProvider.requestFilePath(
            from: fileManager,
            directoryName: option.asset.albumName,
            fileName: fileName)
        
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
    public func stopRecording() async throws -> VideoFile {
        let videoFilePath = try await recorder.stopRecording()
        try await self.albumManager.addToAlbum(filePath: videoFilePath)
        
        return VideoFileGenerator.generate(with: videoFilePath)
    }
    
    /// Mutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func muteWithError() throws -> AespaSession {
        let tuner = AudioTuner(isMuted: true)
        try coreSession.run(tuner)
        return self
    }

    /// Unmutes the audio input for the video recording session.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func unmuteWithError() throws -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setQualityWithError(to preset: AVCaptureSession.Preset) throws -> AespaSession {
        let tuner = QualityTuner(videoQuality: preset)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the camera position for the video recording session.
    ///
    /// - Parameter position: An `AVCaptureDevice.Position` value indicating the camera position to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setPositionWithError(to position: AVCaptureDevice.Position) throws -> AespaSession {
        let tuner = CameraPositionTuner(position: position)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the orientation for the video recording session.
    ///
    /// - Parameter orientation: An `AVCaptureVideoOrientation` value indicating the orientation to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    ///
    /// - Note: It sets the orientation of the video you are recording,
    /// not the orientation of the `AVCaptureVideoPreviewLayer`.
    @discardableResult
    public func setOrientationWithError(to orientation: AVCaptureVideoOrientation) throws -> AespaSession {
        let tuner = VideoOrientationTuner(orientation: orientation)
        try coreSession.run(tuner)
        return self
    }

    /// Sets the stabilization mode for the video recording session.
    ///
    /// - Parameter mode: An `AVCaptureVideoStabilizationMode` value indicating the stabilization mode to be set.
    ///
    /// - Throws: `AespaError` if the session fails to run the tuner.
    ///
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func setAutofocusingWithError(mode: AVCaptureDevice.FocusMode) throws -> AespaSession {
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
    /// - Returns: `AespaSession`, for chaining calls.
    @discardableResult
    public func zoomWithError(factor: CGFloat) throws -> AespaSession {
        let tuner = ZoomTuner(zoomFactor: factor)
        try coreSession.run(tuner)
        return self
    }


    // MARK: - Customizable
    /// This function provides a way to use a custom tuner to modify the current session. The tuner must conform to `AespaSessionTuning`.
    ///
    /// - Parameter tuner: An instance that conforms to `AespaSessionTuning`.
    /// - Throws: If the session fails to run the tuner.
    public func customize<T: AespaSessionTuning>(_ tuner: T) throws {
        try coreSession.run(tuner)
    }

    
    // MARK: - Utilities
    /// Fetches a list of recorded video files. The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of video files to fetch.
    ///     If the limit is set to 0 (default), all recorded video files will be fetched.
    /// - Returns: An array of `VideoFile` instances.
    public func fetchVideoFiles(limit: Int = 0) -> [VideoFile] {
        return fetch(count: limit)
    }
    
    public func fetchVideoFiles(limit: Int = 0) async -> [VideoFile] {
        return await fetch(count: limit)
    }

    /// Checks if essential conditions to start recording are satisfied.
    /// This includes checking for capture authorization, if the session is running,
    /// if there is an existing connection and if a device is attached.
    ///
    /// - Throws: `AespaError.permission` if capture authorization is denied.
    /// - Throws: `AespaError.session` if the session is not running, cannot find a connection, or cannot find a device.
    public func doctor() async throws {
        // Check authorization status
        guard
            case .permitted = await AuthorizationChecker.checkCaptureAuthorizationStatus()
        else {
            throw AespaError.permission(reason: .denied)
        }
        
        guard coreSession.isRunning else {
            throw AespaError.session(reason: .notRunning)
        }
        
        // Check if connection exists
        guard coreSession.movieFileOutput != nil else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        // Check if device is attached
        guard coreSession.videoDeviceInput != nil else {
            throw AespaError.session(reason: .cannotFindDevice)
        }
    }

}

extension AespaSession {
    func startSession() throws {
        let tuner = SessionLaunchTuner()
        try coreSession.run(tuner)
        
        previewLayerSubject.send(previewLayer)
    }
    
    func terminateSession() throws {
        let tuner = SessionTerminationTuner()
        try coreSession.run(tuner)
    }
}

private extension AespaSession {
    /// If `count` is `0`, return all existing files
    func fetch(count: Int) async -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else { return }
            
            DispatchQueue.global(qos: .utility).async {
                let files = self.fetch(count: count)
                continuation.resume(with: .success(files))
            }
        }
    }
    
    /// If `count` is `0`, return all existing files
    func fetch(count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        do {
            let directoryPath = try VideoFilePathProvider.requestDirectoryPath(from: fileManager,
                                                                               name: option.asset.albumName)
            
            let filePaths = try fileManager.contentsOfDirectory(atPath: directoryPath.path)
            let filePathPrefix = count == 0 ? filePaths : Array(filePaths.prefix(count))
            
            return filePathPrefix
                .sorted()
                .reversed()
                .map { name -> URL in
                    return directoryPath.appendingPathComponent(name)
                }
                .map { filePath -> VideoFile in
                    return VideoFileGenerator.generate(with: filePath)
                }
        } catch let error {
            Logger.log(error: error)
            return []
        }
    }
}
