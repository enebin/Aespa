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
    private let fileManager: AespaCoreFileManager
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
            fileManager: .init(enableCaching: option.asset.useVideoFileCache),
            albumManager: .init(albumName: option.asset.albumName)
        )
    }

    init(
        option: AespaOption,
        session: AespaCoreSession,
        recorder: AespaCoreRecorder,
        camera: AespaCoreCamera,
        fileManager: AespaCoreFileManager,
        albumManager: AespaCoreAlbumManager
    ) {
        self.option = option
        self.coreSession = session
        self.recorder = recorder
        self.camera = camera
        self.fileManager = fileManager
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
            fileManager: fileManager,
            option: option)
        
        self.videoContext = AespaVideoContext(
            commonContext: self,
            coreSession: coreSession,
            recorder: recorder,
            albumManager: albumManager,
            fileManager: fileManager,
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

    public func getSubjectAreaDidChangePublisher() -> AnyPublisher<Notification, Never> {
        if isSubjectAreaChangeMonitoringEnabled != true {
            Logger.log(
                message: """
                `isSubjectAreaChangeMonitoringEnabled` is not set `true.
                `AVCaptureDeviceSubjectAreaDidChange` publisher may not publish anything.
                """)
        }
        
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
    public func qualityWithError(to preset: AVCaptureSession.Preset) throws -> AespaSession {
        let tuner = QualityTuner(videoQuality: preset)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func positionWithError(to position: AVCaptureDevice.Position) throws -> AespaSession {
        let tuner = CameraPositionTuner(position: position,
                                        devicePreference: option.session.cameraDevicePreference)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func orientationWithError(to orientation: AVCaptureVideoOrientation) throws -> AespaSession {
        let tuner = VideoOrientationTuner(orientation: orientation)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func focusWithError(mode: AVCaptureDevice.FocusMode, point: CGPoint? = nil) throws -> AespaSession {
        let tuner = FocusTuner(mode: mode, point: point)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func zoomWithError(factor: CGFloat) throws -> AespaSession {
        let tuner = ZoomTuner(zoomFactor: factor)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func changeMonitoringWithError(enabled: Bool) throws -> AespaSession  {
        let tuner = ChangeMonitoringTuner(isSubjectAreaChangeMonitoringEnabled: enabled)
        try coreSession.run(tuner)
        return self
    }
    
    public func customizeWithError<T: AespaSessionTuning>(_ tuner: T) throws -> AespaSession {
        try coreSession.run(tuner)
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
    
    public func startRecordingWithError() throws {
        try videoContext.startRecordingWithError()
    }
    
    @discardableResult
    public func stopRecordingWithError() async throws -> VideoFile {
        try await videoContext.stopRecordingWithError()
    }
    
    @discardableResult
    public func muteWithError() throws -> AespaVideoSessionContext {
        try videoContext.muteWithError()
    }
    
    @discardableResult
    public func unmuteWithError() throws -> AespaVideoSessionContext {
        try videoContext.unmuteWithError()
    }
    
    @discardableResult
    public func stabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaVideoSessionContext {
        try videoContext.stabilizationWithError(mode: mode)
    }
    
    @discardableResult
    public func torchWithError(mode: AVCaptureDevice.TorchMode, level: Float) throws -> AespaVideoSessionContext {
        try videoContext.torchWithError(mode: mode, level: level)
    }
    
    public func fetchVideoFiles(limit: Int) -> [VideoFile] {
        videoContext.fetchVideoFiles(limit: limit)
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

    public func capturePhotoWithError() async throws -> PhotoFile {
        try await photoContext.capturePhotoWithError()
    }

    @discardableResult
    public func flashMode(to mode: AVCaptureDevice.FlashMode) -> AespaPhotoContext {
        photoContext.flashMode(to: mode)
    }

    @discardableResult
    public func redEyeReduction(enabled: Bool) -> AespaPhotoContext {
        photoContext.redEyeReduction(enabled: enabled)
    }

    public func custom(_ setting: AVCapturePhotoSettings) {
        photoSetting = setting
    }
    
    public func fetchPhotoFiles(limit: Int) -> [PhotoFile] {
        photoContext.fetchPhotoFiles(limit: limit)
    }
    
    public func custom(_ setting: AVCapturePhotoSettings) -> AespaPhotoContext {
        photoContext.custom(setting)
    }
}

extension AespaSession {
    func startSession() throws {
        let tuner = SessionLaunchTuner()
        coreSession.start()
        try coreSession.run(tuner)

        previewLayerSubject.send(previewLayer)
    }

    func terminateSession() throws {
        let tuner = SessionTerminationTuner()
        try coreSession.run(tuner)
    }
}
