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

nonisolated class AespaCoreSession: AVCaptureSession, @unchecked Sendable {
    var option: AespaOption
    private let workQueue = DispatchQueue(label: "co.enebin.aespa.session", qos: .background)
    private let queueStateLock = NSRecursiveLock()
    private var isWorkQueueActive = false
    private var pendingWorkItems: [@Sendable () -> Void] = []
    
    init(option: AespaOption) {
        self.option = option
    }
    
    func run<T: AespaSessionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork {
            do {
                if tuner.needTransaction { self.beginConfiguration() }
                defer {
                    if tuner.needTransaction { self.commitConfiguration() }
                    onComplete(.success(()))
                }
                
                try tuner.tune(self)
            } catch let error {
                Logger.log(error: error, message: "in \(tuner)")
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaDeviceTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork {
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
                Logger.log(error: error, message: "in \(tuner)")
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaConnectionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork {
            do {
                guard let connection = self.connections.first else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try tuner.tune(connection)
                onComplete(.success(()))
            } catch let error {
                Logger.log(error: error, message: "in \(tuner)")
                onComplete(.failure(error))
            }
        }
    }
    
    func run<T: AespaMovieFileOutputProcessing>(_ processor: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork {
            do {
                guard let output = self.movieFileOutput else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try processor.process(output)
                onComplete(.success(()))
            } catch let error {
                Logger.log(error: error, message: "in \(processor)")
                onComplete(.failure(error))
            }
        }
    }
    
    func start() throws {
        let session = self
        
        guard session.isRunning == false else {
            activateWorkQueue()
            return
        }

        try session.addMovieInput()
        try session.addMovieFileOutput()
        try session.addCapturePhotoOutput()
        session.startRunning()
        activateWorkQueue()
        
        Logger.log(message: "Session is configured successfully")
    }
}

nonisolated private extension AespaCoreSession {
    func enqueueWork(_ work: @escaping @Sendable () -> Void) {
        queueStateLock.lock()
        if isWorkQueueActive {
            queueStateLock.unlock()
            workQueue.async(execute: work)
        } else {
            pendingWorkItems.append(work)
            queueStateLock.unlock()
        }
    }

    func activateWorkQueue() {
        queueStateLock.lock()
        guard isWorkQueueActive == false else {
            queueStateLock.unlock()
            return
        }

        isWorkQueueActive = true
        let pendingWorkItems = self.pendingWorkItems
        self.pendingWorkItems.removeAll()
        queueStateLock.unlock()

        pendingWorkItems.forEach { workQueue.async(execute: $0) }
    }
}
