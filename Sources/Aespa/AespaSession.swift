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
    private let option: AespaOption
    private let coreSession: AespaCoreSession
    private let recorder: AespaCoreRecorder
    private let camera: AespaCoreCamera
    private let fileManager: AespaCoreFileManager
    private let albumManager: AespaCoreAlbumManager

    private let photoFileBufferSubject: CurrentValueSubject<Result<PhotoFile, Error>?, Never>
    private let videoFileBufferSubject: CurrentValueSubject<Result<VideoFile, Error>?, Never>
    private let previewLayerSubject: CurrentValueSubject<AVCaptureVideoPreviewLayer?, Never>
    
    private var videoContext: AespaVideoContext

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

        self.videoFileBufferSubject = .init(nil)
        self.photoFileBufferSubject = .init(nil)
        self.previewLayerSubject = .init(nil)
        
        self.videoContext = AespaVideoContext(coreSession: coreSession,
                                              recorder: recorder,
                                              albumManager: albumManager,
                                              fileManager: fileManager,
                                              option: option)
        self.capturePhotoSetting = .init()

        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)

        // Add first video file to buffer if it exists
        if let firstVideoFile = fileManager.fetch(albumName: option.asset.albumName, count: 1).first {
            videoFileBufferSubject.send(.success(firstVideoFile))
        }
    }

    // MARK: - vars
    /// This property exposes the underlying `AVCaptureSession` that `Aespa` currently utilizes.
    ///
    /// While you can directly interact with this object, it is strongly recommended to avoid modifications
    /// that could yield unpredictable behavior.
    /// If you require custom configurations,
    /// consider utilizing the `custom` function we offer whenever possible.
    public var captureSession: AVCaptureSession {
        return coreSession
    }

    public var video: AespaVideoContext {
        videoContext
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
    /// Fetches a list of recorded video files.
    /// The number of files fetched is controlled by the limit parameter.
    ///
    /// It is recommended not to be called in main thread.
    ///
    /// - Parameter limit: An integer specifying the maximum number of video files to fetch.
    ///     If the limit is set to 0 (default), all recorded video files will be fetched.
    /// - Returns: An array of `VideoFile` instances.
    public func fetchVideoFiles(limit: Int = 0) -> [VideoFile] {
        return fileManager.fetch(albumName: option.asset.albumName, count: limit)
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
