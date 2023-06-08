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

open class AespaSession {
    private let option: AespaOption
    private let coreSession: AespaCoreSession
    private let recorder: AespaCoreRecorder
    private let fileManager: FileManager
    private let albumManager: AespaCoreAlbumManager
    
    private var currentRecordingURL: URL?
    private let videoFileBufferSubject: CurrentValueSubject<Result<VideoFile, Error>?, Never>
    private let previewLayerSubject: CurrentValueSubject<AVCaptureVideoPreviewLayer?, Never>
    
    public let previewLayer: AVCaptureVideoPreviewLayer
    
    convenience init(option: AespaOption) {
        let session = AespaCoreSession(option: option)
        Logger.enableLogging = option.log.enableLogging
        
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
        
        // Add first file to buffer if it exists
        if let firstVideoFile = fetch(count: 1).first {
            self.videoFileBufferSubject.send(.success(firstVideoFile))
        }
    }
    
    // MARK: vars
    public var isRunning: Bool {
        coreSession.isRunning
    }
    
    public var maxZoomFactor: CGFloat? {
        guard let videoDeviceInput = coreSession.videoDeviceInput else { return nil }
        return videoDeviceInput.device.activeFormat.videoMaxZoomFactor
    }
    
    public var currentZoomFactor: CGFloat? {
        guard let videoDeviceInput = coreSession.videoDeviceInput else { return nil }
        return videoDeviceInput.device.videoZoomFactor
    }
    
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
    
    public var previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never> {
        previewLayerSubject.handleEvents(receiveOutput: { _ in
            Logger.log(message: "Preview layer is updated")
        })
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Methods
    public func startRecording() throws {
        let fileName = option.asset.fileNameHandler()
        let filePath = try VideoFilePathProvider.requestFilePath(
            from: fileManager,
            directoryName: option.asset.albumName,
            fileName: fileName)
        
        if option.session.autoVideoOrientation {
            setOrientation(to: UIDevice.current.orientation.toVideoOrientation)
        }
        
        try recorder.startRecording(in: filePath)
        
        currentRecordingURL = filePath
    }
    
    public func stopRecording() throws {
        try recorder.stopRecording()
        
        if let currentRecordingURL {
            Task(priority: .utility) {
                try await albumManager.addToAlbum(filePath: currentRecordingURL)
            }
        }
    }
    
    // MARK: Chaining
    @discardableResult
    public func mute() throws -> Self {
        let tuner = AudioTuner(isMuted: true)
        try coreSession.run(tuner)
        return self
    }

    @discardableResult
    public func unmute() throws -> Self {
        let tuner = AudioTuner(isMuted: false)
        try coreSession.run(tuner)
        return self
    }

    @discardableResult
    public func setQuality(to preset: AVCaptureSession.Preset) throws -> Self {
        let tuner = QualityTuner(videoQuality: preset)
        try coreSession.run(tuner)
        return self
    }

    @discardableResult
    public func setPosition(to position: AVCaptureDevice.Position) throws -> Self {
        let tuner = CameraPositionTuner(position: position)
        try coreSession.run(tuner)
        return self
    }
    
    // MARK: No throws
    @discardableResult
    public func setOrientation(to orientation: AVCaptureVideoOrientation) -> Self {
        let tuner = VideoOrientationTuner(orientation: orientation)
        try? coreSession.run(tuner)
        return self
    }

    @discardableResult
    public func setStabilization(mode: AVCaptureVideoStabilizationMode) -> Self {
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        try? coreSession.run(tuner)
        return self
    }

    @discardableResult
    public func zoom(factor: CGFloat) -> Self {
        let tuner = ZoomTuner(zoomFactor: factor)
        try? coreSession.run(tuner)
        return self
    }
    
    // MARK: customizable
    public func custom(_ tuner: some AespaSessionTuning) throws {
        try coreSession.run(tuner)
    }
    
    // MARK: Util
    public func fetchVideoFiles(limit: Int = 0) -> [VideoFile] {
        return fetch(count: limit)
    }
    
    /// Check if essential(and minimum) condition for starting recording is satisfied
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
    
    // MARK: Internal
    func startSession() throws {
        let tuner = SessionLaunchTuner()
        try coreSession.run(tuner)
        
        previewLayerSubject.send(previewLayer)
    }
}

private extension AespaSession {
    /// If `count` is `0`, return all files
    func fetch(count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        do {
            let directoryPath = try VideoFilePathProvider.requestDirectoryPath(from: fileManager,
                                                                               name: option.asset.albumName)
            
            let filePaths = try fileManager.contentsOfDirectory(atPath: directoryPath.path)
            let filePathPrefix = count == 0 ? filePaths : Array(filePaths.prefix(count))
            
            return filePathPrefix
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
