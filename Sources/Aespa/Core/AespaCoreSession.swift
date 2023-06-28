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
    
    private let lock = NSRecursiveLock()

    init(option: AespaOption) {
        self.option = option
        lock.lock()
    }

    func run<T: AespaSessionTuning>(_ tuner: T) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if tuner.needTransaction { self.beginConfiguration() }
        defer {
            if tuner.needTransaction { self.commitConfiguration() }
        }

        try tuner.tune(self)
    }

    func run<T: AespaDeviceTuning>(_ tuner: T) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let device = self.videoDeviceInput?.device else {
            throw AespaError.device(reason: .invalid)
        }

        if tuner.needLock { try device.lockForConfiguration() }
        defer {
            if tuner.needLock { device.unlockForConfiguration() }
        }

        try tuner.tune(device)
    }

    func run<T: AespaConnectionTuning>(_ tuner: T) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let connection = self.connections.first else {
            throw AespaError.session(reason: .cannotFindConnection)
        }

        try tuner.tune(connection)
    }

    func run<T: AespaMovieFileOutputProcessing>(_ processor: T) throws {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        guard let output = self.movieFileOutput else {
            throw AespaError.session(reason: .cannotFindConnection)
        }

        try processor.process(output)
    }
    
    func start() {
        // Do soemthing
        print("Start")
        lock.unlock()
    }
}
