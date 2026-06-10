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
    private var pendingWorkItems: [PendingWorkItem] = []
    
    init(option: AespaOption) {
        self.option = option
    }
    
    func run<T: AespaSessionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork({
            do {
                if tuner.needTransaction { self.beginConfiguration() }
                defer {
                    if tuner.needTransaction { self.commitConfiguration() }
                }
                
                try tuner.tune(self)
                onComplete(.success(()))
            } catch let error {
                Logger.log(error: error, message: "in \(tuner)")
                onComplete(.failure(error))
            }
        }, onStartFailure: { onComplete(.failure($0)) })
    }
    
    func run<T: AespaDeviceTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork({
            do {
                guard let device = self.videoDeviceInput?.device else {
                    throw AespaError.device(reason: .invalid)
                }
                
                if tuner.needLock { try device.lockForConfiguration() }
                defer {
                    if tuner.needLock { device.unlockForConfiguration() }
                }
                
                try tuner.tune(device)
                onComplete(.success(()))
            } catch let error {
                Logger.log(error: error, message: "in \(tuner)")
                onComplete(.failure(error))
            }
        }, onStartFailure: { onComplete(.failure($0)) })
    }
    
    func run<T: AespaConnectionTuning>(_ tuner: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork({
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
        }, onStartFailure: { onComplete(.failure($0)) })
    }
    
    func run<T: AespaMovieFileOutputProcessing>(_ processor: T, _ onComplete: @escaping CompletionHandler) {
        enqueueWork({
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
        }, onStartFailure: { onComplete(.failure($0)) })
    }
    
    func start() throws {
        do {
            try workQueue.sync {
                guard self.isRunning == false else {
                    return
                }
                
                try self.addMovieInput()
                try self.addMovieFileOutput()
                try self.addCapturePhotoOutput()
                self.startRunning()
            }
            
            activateWorkQueue()
            Logger.log(message: "Session is configured successfully")
        } catch {
            activateWorkQueue(failingWith: error)
            throw error
        }
    }
}

nonisolated private extension AespaCoreSession {
    struct PendingWorkItem {
        let work: @Sendable () -> Void
        let onStartFailure: @Sendable (Error) -> Void
    }
    
    func enqueueWork(
        _ work: @escaping @Sendable () -> Void,
        onStartFailure: @escaping @Sendable (Error) -> Void
    ) {
        queueStateLock.lock()
        if isWorkQueueActive {
            queueStateLock.unlock()
            workQueue.async(execute: work)
        } else {
            pendingWorkItems.append(PendingWorkItem(work: work, onStartFailure: onStartFailure))
            queueStateLock.unlock()
        }
    }

    func activateWorkQueue(failingWith error: Error? = nil) {
        queueStateLock.lock()
        guard isWorkQueueActive == false else {
            queueStateLock.unlock()
            return
        }

        isWorkQueueActive = true
        let pendingWorkItems = self.pendingWorkItems
        self.pendingWorkItems.removeAll()
        queueStateLock.unlock()

        pendingWorkItems.forEach { item in
            if let error {
                item.onStartFailure(error)
            } else {
                workQueue.async(execute: item.work)
            }
        }
    }
}
