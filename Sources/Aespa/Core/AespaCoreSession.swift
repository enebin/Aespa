//
//  AespaCoreSessionManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import UIKit
import Combine
import Foundation
import AVFoundation

class AespaCoreSession: AVCaptureSession {
    var option: AespaOption
    private var workQueue = OperationQueue()
    
    init(option: AespaOption) {
        self.option = option
        
        workQueue.qualityOfService = .background
        workQueue.maxConcurrentOperationCount = 1
        workQueue.isSuspended = true
    }
    
    func run<T: AespaSessionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        workQueue.addOperation {
            do {
                if tuner.needTransaction { self.beginConfiguration() }
                defer {
                    if tuner.needTransaction { self.commitConfiguration() }
                    onComplete(.success(()))
                }
                
                try tuner.tune(self)
            } catch let error {
                print(tuner)
                Logger.log(error: error)
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaDeviceTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        workQueue.addOperation {
            do {
                guard let device = self.videoDeviceInput?.device else {
                    throw AespaError.device(reason: .invalid)
                }
                
                if tuner.needLock { try device.lockForConfiguration() }
                defer {
                    if tuner.needLock { device.unlockForConfiguration() }
                    onComplete(.success(()))
                }
                
                try tuner.tune(device)
            } catch let error {
                print(tuner)
                Logger.log(error: error)
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaConnectionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        workQueue.addOperation {
            do {
                guard let connection = self.connections.first else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try tuner.tune(connection)
                onComplete(.success(()))
            } catch let error {
                print(tuner)
                Logger.log(error: error)
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaMovieFileOutputProcessing>(_ processor: T, _ onComplete: @escaping CompletionHandler) {
        workQueue.addOperation {
            do {
                guard let output = self.movieFileOutput else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try processor.process(output)
                onComplete(.success(()))
            } catch let error {
                print(processor)
                Logger.log(error: error)
                onComplete(.failure(error))
            }
        }
    }
    
    func start() throws {
        let session = self
        
        guard session.isRunning == false else { return }

        try session.addMovieInput()
        try session.addMovieFileOutput()
        try session.addCapturePhotoOutput()
        session.startRunning()
        
        self.workQueue.isSuspended = false
        Logger.log(message: "Session is configured successfully")
    }
}
