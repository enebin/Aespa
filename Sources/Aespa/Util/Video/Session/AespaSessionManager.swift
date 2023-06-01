//
//  AespaSessionManager.swift
//
//
//  Created by Young Bin on 2023/05/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

final class AespaSessionManager: NSObject {
    typealias AssetOption = AespaOption.Asset
    typealias SessionOption = AespaOption.Session
    
    private var sessionOption: SessionOption
    private var assetOption: AssetOption
    
    private let videoFileGenerator: VideoFileGeneratingService
    
    private let authorizationManager: AuthorizationManager
    private let videoFileManager: VideoFileManager
    
    var isConfigured: Bool { internalSession != nil }
    private var internalSession: AVCaptureSession?
    
    private let videoFileIoBufferSubject = CurrentValueSubject<VideoFileBufferStatus, Never>(.undefined)
    private let previewLayerSubject = CurrentValueSubject<AVCaptureVideoPreviewLayer, Never>(.init())
    
    convenience init(
        sessionOption: SessionOption,
        assetOption: AssetOption
    ) {
        self.init(
            sessionOption: sessionOption,
            assetOption: assetOption,
            videoFileGenerator: .init(),
            authorizationManager: .init(),
            videoFileManager: .init(option: assetOption))
    }
    
    init(
        sessionOption: SessionOption,
        assetOption: AssetOption,
        videoFileGenerator: VideoFileGeneratingService,
        authorizationManager: AuthorizationManager,
        videoFileManager: VideoFileManager
    ) {
        self.sessionOption = sessionOption
        self.assetOption = assetOption
        self.videoFileGenerator = videoFileGenerator
        self.authorizationManager = authorizationManager
        self.videoFileManager = videoFileManager
    }
    
}

extension AespaSessionManager {
    var session: AVCaptureSession? {
        return internalSession
    }
    
    var videoFileIoStatusPublisher: AnyPublisher<VideoFileBufferStatus, Never> {
        videoFileIoBufferSubject.eraseToAnyPublisher()
    }
    
    var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        previewLayerSubject.eraseToAnyPublisher()
    }
    
    /// Configure and running `AVCaptureSession`
    ///
    /// - Warning: Recommend running in background
    @discardableResult
    func configureSession() throws -> AVCaptureSession {
        if let session = internalSession {
            return session
        }
        
        // Make a new session
        let newSession = try AVCaptureSession()
            .addMovieInput()
            .connectMovieOutput()
        
        try perform(
            commands: [
                .position(sessionOption.cameraPosition),
                .quailty(sessionOption.videoQuality),
                sessionOption.silentMode ? .mute : .unmute
            ],
            for: newSession)
        
        
        // Load first file to buffer
        if let firstVideoFile = videoFileManager.fetch().first {
            videoFileIoBufferSubject.send(.done(firstVideoFile))
        }
        
        Task(priority: .background) {
            // Checking authorization status
            guard
                case .permitted = await authorizationManager.checkCaptureAuthorizationStatus()
            else {
                throw AespaError.permission(reason: .denied)
            }
            
            // Recommed to be done in background priority(by docs)
            newSession.startRunning()
            self.previewLayerSubject.send(newSession.previewLayer)
        }
        
        internalSession = newSession
        return newSession
    }
    
    /// Check if essential(and minimum) condition for starting recording is satisfied
    func doctor() async throws {
        // Check authorization status
        guard
            case .permitted = await authorizationManager.checkCaptureAuthorizationStatus()
        else {
            throw AespaError.permission(reason: .denied)
        }
        
        // Check if session's configured
        guard let session = internalSession else {
            throw AespaError.session(reason: .notConfigured)
        }
        
        guard session.isRunning else {
            throw AespaError.session(reason: .notRunning)
        }
        
        // Check if connection exists
        guard session.movieOutput != nil else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        // Check if device is attached
        guard session.videoDevice != nil else {
            throw AespaError.session(reason: .cannotFindDevice)
        }
    }
}

extension AespaSessionManager: Manager {
    enum RunningCommand {
        case startRecording
        case stopRecording
        case changeZoomFactor(CGFloat)
        case quailty(AVCaptureSession.Preset)
        case mute
        case unmute
        case position(AVCaptureDevice.Position)
        case orienetation(AVCaptureVideoOrientation)
        case stabilizationMode(AVCaptureVideoStabilizationMode)
    }
    
    func perform(_ command: RunningCommand) throws {
        guard let session = internalSession else {
            fatalError("perform before session configured")
        }
        
        try perform(commands: [command], for: session)
    }
}

private extension AespaSessionManager {
    func terminateSession() {
        internalSession?.stopRunning()
        internalSession = nil
    }
    
    func startRecording() throws {
        guard let session = internalSession else {
            throw AespaError.session(reason: .notConfigured)
        }
        
        guard session.isRunning else {
            fatalError("Session is not running")
        }
        
        guard
            let output = session.movieOutput,
            output.connection(with: .video) != nil
        else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        let filePath = try videoFileManager.requestFilePath()
        output.startRecording(to: filePath, recordingDelegate: self)
    }
    
    func stopRecording() throws {
        guard let internalSession else {
            throw AespaError.session(reason: .notConfigured)
        }
        
        let output = internalSession.movieOutput
        output?.stopRecording()
    }
    
    func perform(commands: [RunningCommand], for session: AVCaptureSession) throws {
        guard
            let connection = session.connections.first
        else {
            throw AespaError.session(reason: .notConfigured)
        }
        
        try commands.forEach { command in
            switch command {
            case .startRecording:
                try startRecording()
            case .stopRecording:
                try stopRecording()
            case .changeZoomFactor(let factor):
                session.videoDevice?.setZoomFactor(factor: factor)
            case .quailty(let preset):
                session.setVideoQuality(to: preset)
            case .mute:
                try session.addAudioInput()
            case .unmute:
                session.removeAudioInput()
            case .position(let position):
                try session.setCameraPosition(to: position)
            case .orienetation(let orientation):
                connection.setOrientation(to: orientation)
            case .stabilizationMode(let mode):
                connection.setStabilizationMode(to: mode)
            }
        }
    }
}

extension AespaSessionManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        LoggingManager.logger.log(message: "Recording started")
    }
    
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        LoggingManager.logger.log(message: "Recording stopped")
        
        if let error {
            LoggingManager.logger.log(error: error)
            try? stopRecording()
            videoFileIoBufferSubject.send(.error(error))
        }
        
        // Check wheter it can access the specified album url
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {
            Task(priority: .background) {
                do {
                    let videoFile = videoFileGenerator.process(.generatingVideoFile(path: outputFileURL))
                    try await videoFileManager.add(videoFile: videoFile)
                    videoFileIoBufferSubject.send(.done(videoFile))
                } catch let error {
                    videoFileIoBufferSubject.send(.error(error))
                }
            }
        } else {
            videoFileIoBufferSubject.send(.error(AespaError.album(reason: .unabledToAccess)))
        }
    }
}
