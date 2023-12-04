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

/// The `AespaSession` is a Swift interface which provides a wrapper
/// around the `AVFoundation`'s `AVCaptureSession`,
/// simplifying its use for video capture.
///
/// The interface allows you to start and stop recording, manage device input and output,
/// change video quality and camera's position, etc.
/// For more option, you can use customization method to handle session with your own logic.
///
/// It also includes functionalities to fetch video files.
open class AespaSession {
    let option: AespaOption
    let coreSession: AespaCoreSession
    private let albumManager: AespaCoreAlbumManager
    
    private let recorder: AespaCoreRecorder
    private let camera: AespaCoreCamera

    private let previewLayerSubject: CurrentValueSubject<AVCaptureVideoPreviewLayer?, Never>
    
    private var photoSetting: AVCapturePhotoSettings
    
    private var videoContext: AespaVideoContext<AespaSession>!
    private var photoContext: AespaPhotoContext!

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
            camera: .init(core: session),
            albumManager: .init(albumName: option.asset.albumName)
        )
    }

    init(
        option: AespaOption,
        session: AespaCoreSession,
        recorder: AespaCoreRecorder,
        camera: AespaCoreCamera,
        albumManager: AespaCoreAlbumManager
    ) {
        self.option = option
        self.coreSession = session
        self.recorder = recorder
        self.camera = camera
        self.albumManager = albumManager
        
        self.previewLayerSubject = .init(nil)
        
        self.photoSetting = .init()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        setupContext()
    }
    
    private func setupContext() {
        self.photoContext = AespaPhotoContext(
            coreSession: coreSession,
            camera: camera,
            albumManager: albumManager,
            option: option)
        
        self.videoContext = AespaVideoContext(
            commonContext: self,
            coreSession: coreSession,
            recorder: recorder,
            albumManager: albumManager,
            option: option)
    }

    // MARK: - Public variables
    /// This property exposes the underlying `AVCaptureSession` that `Aespa` currently utilizes.
    ///
    /// - Warning: While you can directly interact with this object, it is strongly recommended to avoid modifications
    ///     that could yield unpredictable behavior.
    ///     If you require custom configurations, consider utilizing the `custom` function we offer whenever possible.
    public var avCaptureSession: AVCaptureSession {
        coreSession
    }
    
    /// This property indicates whether the current session is active or not.
    public var isRunning: Bool {
        coreSession.isRunning
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
    
    /// This property reflects the current zoom factor applied to the video device.
    public var currentFocusMode: AVCaptureDevice.FocusMode? {
        guard let videoDeviceInput = coreSession.videoDeviceInput else { return nil }
        return videoDeviceInput.device.focusMode
    }
    
    /// This property reflects the session's current orientation.
    public var currentOrientation: AVCaptureVideoOrientation? {
        guard let connection = coreSession.connections.first else { return nil }
        return connection.videoOrientation
    }
    
    /// This property reflects the device's current position.
    public var currentCameraPosition: AVCaptureDevice.Position? {
        guard let device = coreSession.videoDeviceInput?.device else { return nil }
        return device.position
    }
    
    /// This property indicates whether the camera device is set to monitor changes in the subject area.
    ///
    /// Enabling subject area change monitoring allows the device to adjust focus and exposure settings automatically
    /// when the subject within the specified area changes.
    public var isSubjectAreaChangeMonitoringEnabled: Bool? {
        guard let device = coreSession.videoDeviceInput?.device else { return nil }
        return device.isSubjectAreaChangeMonitoringEnabled
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
    
    // MARK: - Utilities
    /// Returns a publisher that emits a `Notification` when the subject area of the capture device changes.
    ///
    /// This is useful when you want to react to changes in the capture device's subject area,
    /// such as when the user changes the zoom factor, or when the device changes its autofocus area.
    ///
    /// - Returns: An `AnyPublisher` instance that emits `Notification` values.
    public func getSubjectAreaDidChangePublisher() -> AnyPublisher<Notification, Never> {
        return NotificationCenter.default
            .publisher(for: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange)
            .eraseToAnyPublisher()
    }
    
    /// Checks if essential conditions to start recording are satisfied.
    /// This includes checking for capture authorization, if the session is running,
    /// if there is an existing connection and if a device is attached.
    ///
    /// - Throws: `AespaError.permission` if capture authorization is denied.
    /// - Throws: `AespaError.session` if the session is not running,
    ///     cannot find a connection, or cannot find a device.
    public func doctor() async throws {
        // Check authorization status
        guard
            case .permitted = await AuthorizationChecker.checkCaptureAuthorizationStatus()
        else {
            throw AespaError.permission(reason: .denied)
        }

        // Check if session is running
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

extension AespaSession: CommonContext {
    public var underlyingCommonContext: AespaSession {
        self
    }
    
    @discardableResult
    public func common(
        _ commonContextOption: CommonContextOption,
        onComplete: CompletionHandler? = nil
    ) -> AespaSession {
        let onComplete = onComplete ?? { _ in }
        
        switch commonContextOption {
        case .quality(let preset):
            let tuner = QualityTuner(videoQuality: preset)
            coreSession.run(tuner, onComplete)
            
        case .position(let position):
            let tuner = CameraPositionTuner(
                position: position,
                devicePreference: option.session.cameraDevicePreference)
            coreSession.run(tuner, onComplete)
            
        case .orientation(let orientation):
            let tuner = VideoOrientationTuner(orientation: orientation)
            coreSession.run(tuner, onComplete)

        case .focus(let mode, let point):
            let tuner = FocusTuner(mode: mode, point: point)
            coreSession.run(tuner, onComplete)
            
        case .zoom(let factor):
            let tuner = ZoomTuner(zoomFactor: factor)
            coreSession.run(tuner, onComplete)
            
        case .changeMonitoring(let enabled):
            let tuner = ChangeMonitoringTuner(isSubjectAreaChangeMonitoringEnabled: enabled)
            coreSession.run(tuner, onComplete)
            
        case .custom(let tuner):
            coreSession.run(tuner, onComplete)
        }
        
        return self
    }
}

extension AespaSession: VideoContext {
    public typealias AespaVideoSessionContext = AespaVideoContext<AespaSession>

    public var underlyingVideoContext: AespaVideoSessionContext {
        videoContext
    }

    public var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        videoContext.videoFilePublisher
    }

    public var isRecording: Bool {
        videoContext.isRecording
    }

    public var isMuted: Bool {
        videoContext.isMuted
    }

    public func startRecording(
        at path: URL? = nil,
        autoVideoOrientationEnabled: Bool = false,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) {
        videoContext.startRecording(at: path, autoVideoOrientationEnabled: autoVideoOrientationEnabled, onComplete)
    }
    
    public func stopRecording(_ completionHandler: @escaping (Result<VideoFile, Error>) -> Void = { _ in }) {
        videoContext.stopRecording(completionHandler)
    }
    
    public func fetchVideoFiles(limit: Int = 0) async -> [VideoAsset] {
        return await videoContext.fetchVideoFiles(limit: limit)
    }
    
    @discardableResult
    public func video(
        _ videoContextOption: VideoContextOption,
        onComplete: CompletionHandler? = nil
    ) -> AespaVideoSessionContext {
        let onComplete = onComplete ?? { _ in }
        return videoContext.video(videoContextOption, onComplete: onComplete)
    }
}

extension AespaSession: PhotoContext {
    public var underlyingPhotoContext: AespaPhotoContext {
        photoContext
    }
    
    public var photoFilePublisher: AnyPublisher<Result<PhotoFile, Error>, Never> {
        photoContext.photoFilePublisher
    }
    
    public var currentSetting: AVCapturePhotoSettings {
        photoContext.currentSetting
    }

    public func capturePhoto(_ completionHandler: @escaping (Result<PhotoFile, Error>) -> Void = { _ in }) {
        photoContext.capturePhoto(completionHandler)

    }
    
    public func fetchPhotoFiles(limit: Int = 0) async -> [PhotoAsset] {
        return await photoContext.fetchPhotoFiles(limit: limit)
    }
    
    @discardableResult
    public func photo(
        _ photoContextOption: PhotoContextOption,
        onComplete: CompletionHandler? = nil
    ) -> AespaPhotoContext {
        let onComplete = onComplete ?? { _ in }
        return photoContext.photo(photoContextOption, onComplete: onComplete)
    }
}

extension AespaSession {
    func startSession(_ onComplete: @escaping CompletionHandler) {
        do {
            try coreSession.start()
            previewLayerSubject.send(previewLayer)
        } catch let error {
            onComplete(.failure(error))
        }
    }
    
    func terminateSession(_ onComplete: @escaping CompletionHandler) {
        let tuner = SessionTerminationTuner()
        coreSession.run(tuner, onComplete)
    }
}

// MARK: - Deprecated methods
extension AespaSession {
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func quality(
        to preset: AVCaptureSession.Preset,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        let tuner = QualityTuner(videoQuality: preset)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func position(
        to position: AVCaptureDevice.Position,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        let tuner = CameraPositionTuner(position: position,
                                        devicePreference: option.session.cameraDevicePreference)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func orientation(
        to orientation: AVCaptureVideoOrientation,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        let tuner = VideoOrientationTuner(orientation: orientation)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func focus(
        mode: AVCaptureDevice.FocusMode, point: CGPoint? = nil,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        let tuner = FocusTuner(mode: mode, point: point)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func zoom(factor: CGFloat, _ onComplete: @escaping CompletionHandler = { _ in }) -> AespaSession {
        let tuner = ZoomTuner(zoomFactor: factor)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func changeMonitoring(enabled: Bool, _ onComplete: @escaping CompletionHandler = { _ in }) -> AespaSession {
        let tuner = ChangeMonitoringTuner(isSubjectAreaChangeMonitoringEnabled: enabled)
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `common` instead.")
    @discardableResult
    public func custom<T: AespaSessionTuning>(
        _ tuner: T,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        coreSession.run(tuner, onComplete)
        return self
    }
    
    @available(*, deprecated, message: "Please use `video` instead.")
    @discardableResult
    public func mute(_ onComplete: @escaping CompletionHandler = { _ in }) -> AespaVideoSessionContext {
        videoContext.mute(onComplete)
    }
    
    @available(*, deprecated, message: "Please use `video` instead.")
    @discardableResult
    public func unmute(_ onComplete: @escaping CompletionHandler = { _ in }) -> AespaVideoSessionContext {
        videoContext.unmute(onComplete)
    }
    
    @available(*, deprecated, message: "Please use `video` instead.")
    @discardableResult
    public func stabilization(
        mode: AVCaptureVideoStabilizationMode,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaVideoSessionContext {
        videoContext.stabilization(mode: mode, onComplete)
    }
    
    @available(*, deprecated, message: "Please use `video` instead.")
    @discardableResult
    public func torch(
        mode: AVCaptureDevice.TorchMode,
        level: Float,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaVideoSessionContext {
        videoContext.torch(mode: mode, level: level, onComplete)
    }
    
    @available(*, deprecated, message: "Please use `photo` instead.")
    @discardableResult
    public func flashMode(to mode: AVCaptureDevice.FlashMode) -> AespaPhotoContext {
        photoContext.flashMode(to: mode)
    }
    
    @available(*, deprecated, message: "Please use `photo` instead.")
    @discardableResult
    public func redEyeReduction(enabled: Bool) -> AespaPhotoContext {
        photoContext.redEyeReduction(enabled: enabled)
    }
    
    @available(*, deprecated, message: "Please use `photo` instead.")
    @discardableResult
    public func custom(_ setting: AVCapturePhotoSettings) -> AespaPhotoContext {
        photoContext.custom(setting)
    }
}
