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

    /// A Boolean value that indicates whether the session is currently recording video.
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
            count: 1).first {
            videoFileBufferSubject.send(.success(firstVideoFile))
        }
        
        Task {
            print(try await albumManager.fetchPhotoFile(limit: 0))
//            print(try await albumManager.fetchPHAsset(mediaType: .image, limit: 0).count)
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
    
    public func startRecording(_ onComplete: @escaping CompletionHandler = { _ in }) {
        do {
            let fileName = option.asset.fileNameHandler()
            let filePath = try FilePathProvider.requestFilePath(
                from: fileManager.systemFileManager,
                directoryName: option.asset.albumName,
                subDirectoryName: option.asset.videoDirectoryName,
                fileName: fileName,
                extension: "mp4")
            
            if option.session.autoVideoOrientationEnabled {
                commonContext.orientation(to: UIDevice.current.orientation.toVideoOrientation, onComplete)
            }
            
            recorder.startRecording(in: filePath, onComplete)
            isRecording = true
        } catch let error {
            onComplete(.failure(error))
        }
    }
    
    public func stopRecording(_ onCompelte: @escaping ResultHandler<VideoFile> = { _ in }) {
        Task(priority: .utility) {
            do {
                let videoFilePath = try await recorder.stopRecording()
                let videoFile = VideoFileGenerator.generate(with: videoFilePath, date: Date())

                try await albumManager.addToAlbum(filePath: videoFilePath)
                videoFileBufferSubject.send(.success(videoFile))

                isRecording = false
                onCompelte(.success(videoFile))
            } catch let error {
                Logger.log(error: error)
                onCompelte(.failure(error))
            }
        }
    }
    
    @discardableResult
    public func mute(_ onComplete: @escaping CompletionHandler = { _ in }) -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: true)
        coreSession.run(tuner, onComplete)
        
        return self
    }
    
    @discardableResult
    public func unmute(_ onComplete: @escaping CompletionHandler = { _ in }) -> AespaVideoContext {
        let tuner = AudioTuner(isMuted: false)
        coreSession.run(tuner, onComplete)
        
        return self
    }
    
    @discardableResult
    public func stabilization(
        mode: AVCaptureVideoStabilizationMode,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaVideoContext {
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        coreSession.run(tuner, onComplete)
        
        return self
    }
    
    @discardableResult
    public func torch(
        mode: AVCaptureDevice.TorchMode,
        level: Float,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaVideoContext {
        let tuner = TorchTuner(level: level, torchMode: mode)
        coreSession.run(tuner, onComplete)
        
        return self
    }
    
    public func customize<T: AespaSessionTuning>(
        _ tuner: T,
        _ onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaVideoContext {
        coreSession.run(tuner, onComplete)
        
        return self
    }
    
    public func fetchVideoFiles(limit: Int = 0) async -> [VideoAssetFile] {
        return await albumManager.fetchVideoFile(limit: limit)
    }
}
