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
public class AespaVideoContext<Common: CommonContext> {
    private let commonContext: Common
    private let coreSession: AespaCoreSession
    private let albumManager: AespaCoreAlbumManager
    private let fileManager: AespaCoreFileManager
    private let option: AespaOption

    private let recorder: AespaCoreRecorder
    
    private let videoFileBufferSubject: CurrentValueSubject<Result<VideoFile, Error>?, Never>

    public var isRecording: Bool

    init(
        commonContext: Common,
        coreSession: AespaCoreSession,
        recorder: AespaCoreRecorder,
        albumManager: AespaCoreAlbumManager,
        fileManager: AespaCoreFileManager,
        option: AespaOption
    ) {
        self.commonContext = commonContext
        self.coreSession = coreSession
        self.recorder = recorder
        self.albumManager = albumManager
        self.fileManager = fileManager
        self.option = option
        
        self.videoFileBufferSubject = .init(nil)
        
        self.isRecording = false
        
        // Add first video file to buffer if it exists
        if let firstVideoFile = fileManager.fetchVideo(
            albumName: option.asset.albumName,
            subDirectoryName: option.asset.videoDirectoryName,
            count: 1).first
        {
            videoFileBufferSubject.send(.success(firstVideoFile))
        }
    }
}

extension AespaVideoContext: VideoContext {
    public var underlyingVideoContext: AespaVideoContext {
        self
    }
    
    public var isMuted: Bool {
        coreSession.audioDeviceInput == nil
    }
    public var videoFilePublisher: AnyPublisher<Result<VideoFile, Error>, Never> {
        videoFileBufferSubject.handleEvents(receiveOutput: { status in
            if case .failure(let error) = status {
                Logger.log(error: error)
            }
        })
        .compactMap({ $0 })
        .eraseToAnyPublisher()
    }
    
    public func startRecordingWithError() throws {
        let fileName = option.asset.fileNameHandler()
        let filePath = try FilePathProvider.requestFilePath(
            from: fileManager.systemFileManager,
            directoryName: option.asset.albumName,
            subDirectoryName: option.asset.videoDirectoryName,
            fileName: fileName,
            extension: "mp4")
        
        if option.session.autoVideoOrientationEnabled {
            try commonContext.setOrientationWithError(to: UIDevice.current.orientation.toVideoOrientation)
        }

        try recorder.startRecording(in: filePath)
    }
    
    public func stopRecordingWithError() async throws -> VideoFile {
        let videoFilePath = try await recorder.stopRecording()
        let videoFile = VideoFileGenerator.generate(with: videoFilePath, date: Date())

        try await albumManager.addToAlbum(filePath: videoFilePath)
        videoFileBufferSubject.send(.success(videoFile))

        return videoFile
    }
    
    @discardableResult
    public func muteWithError() throws -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: true)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func unmuteWithError() throws -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: false)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func setStabilizationWithError(mode: AVCaptureVideoStabilizationMode) throws -> AespaVideoContext {
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        try coreSession.run(tuner)
        return self
    }
    
    @discardableResult
    public func setTorchWithError(mode: AVCaptureDevice.TorchMode, level: Float) throws -> AespaVideoContext {
        let tuner = TorchTuner(level: level, torchMode: mode)
        try coreSession.run(tuner)
        return self
    }

    public func customizewWithError<T: AespaSessionTuning>(_ tuner: T) throws -> AespaVideoContext {
        try coreSession.run(tuner)
        return self
    }
    
    public func fetchVideoFiles(limit: Int) -> [VideoFile] {
        return fileManager.fetchVideo(
            albumName: option.asset.albumName,
            subDirectoryName: option.asset.videoDirectoryName,
            count: limit)
    }
}
