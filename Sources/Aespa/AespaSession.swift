//
//  AespaSession.swift
//  
//
//  Created by Young Bin on 2023/05/29.
//

import Foundation
import Combine
import AVFoundation

/// Make sure that any other session is running. If so, it won't be started and throw fatal error

open class AespaSession {
    public static let `default` = AespaSession()
    public var isConfigured = false
    
    public private(set) var option: AespaOption
    private var manager: AespaSessionManager
    
    // MARK: - Init
    convenience init() {
        let rootOption = AespaOption(albumName: "Aespa", orientation: .portrait)
        self.init(option: rootOption)
    }
    
    init(option rootOption: AespaOption) {
        self.option = rootOption
        self.manager = AespaSessionManager(sessionOption: rootOption.session, assetOption: rootOption.asset)
    }
    
    // MARK: - Setting
    public func configure(with option: AespaOption) -> Result<AespaSession, Error> {
        if isConfigured {
            LoggingManager.logger.log(message: "Session has already been configured somewhere else")
            return .success(self)
        }
        
        self.manager = AespaSessionManager(sessionOption: option.session, assetOption: option.asset)
        do {
            try manager.configureSession()
        } catch let error {
            return .failure(error)
        }
        
        isConfigured = true
        LoggingManager.logger.log(message: "Finished configuring session.")
        
        return .success(self)
    }
    
    public func doctor() async throws {
        return try await manager.doctor()
    }
    
    // MARK: - Public properties
    /// - Warning: In most cases, you don't need to deal with `AVCaptureSession` directly.
    ///     Be careful to use it.
    public var avCaptureSession: AVCaptureSession? {
        manager.session
    }
    
    public var previewLayer: AVCaptureVideoPreviewLayer? {
        guard let session = manager.session else {
            return nil
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.connection?.videoOrientation = .portrait
        
        return previewLayer
    }
    
    public var maxZoomFactor: CGFloat? {
        guard let videoDeviceInput = manager.session?.videoDevice else { return nil }
        return videoDeviceInput.device.activeFormat.videoMaxZoomFactor
    }
    
    public var currentZoomFactor: CGFloat? {
        guard let videoDeviceInput = manager.session?.videoDevice else { return nil }
        return videoDeviceInput.device.videoZoomFactor
    }
    
    public var videoFileIOStatusPublisher: AnyPublisher<VideoFileBufferStatus, Never> {
        manager.videoFileIoStatusPublisher.handleEvents(
            receiveOutput: { status in
                if case .error(let error) = status {
                    LoggingManager.logger.log(error: error)
                }
            })
        .eraseToAnyPublisher()
    }
    
    public var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        manager.previewLayerPublisher.handleEvents(
            receiveOutput: { _ in
                LoggingManager.logger.log(message: "Preview layer is updated")
            })
        .eraseToAnyPublisher()
    }
    
    // MARK: - Public methods
    // MARK: Throws
    public func startRecordings() throws {
        try manager.perform(.startRecording)
    }

    public func stopRecordings() throws {
        try manager.perform(.stopRecording)
    }

    public func mute() throws {
        try manager.perform(.mute)
    }

    public func unmute() throws {
        try manager.perform(.unmute)
    }

    public func changeQuality(to preset: AVCaptureSession.Preset) throws {
        try manager.perform(.quailty(preset))
    }
    
    public func changePosition(to position: AVCaptureDevice.Position) throws {
        try manager.perform(.position(position))
    }
    
    // MARK: No throws
    public func changeOrientation(to orientation: AVCaptureVideoOrientation) {
        try? manager.perform(.orienetation(orientation))
    }

    public func zoom(factor: CGFloat) {
        try? manager.perform(.changeZoomFactor(factor))
    }
}
