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
    
    var workQueue = DispatchQueue(label: "coreSession.workQueue", qos: .background)
    
    init(option: AespaOption) {
        self.option = option
    }
    
    func run<T: AespaSessionTuning>(_ tuner: T, _ errorHandler: @escaping ErrorHandler) {
        workQueue.async {
            do {
                if tuner.needTransaction { self.beginConfiguration() }
                defer {
                    if tuner.needTransaction { self.commitConfiguration() }
                }
                
                try tuner.tune(self)
            } catch let error {
                errorHandler(error)
            }
        }
    }
    
    func run<T: AespaDeviceTuning>(_ tuner: T, _ errorHandler: @escaping ErrorHandler) {
        workQueue.async {
            do {
                guard let device = self.videoDeviceInput?.device else {
                    throw AespaError.device(reason: .invalid)
                }
                
                if tuner.needLock { try device.lockForConfiguration() }
                defer {
                    if tuner.needLock { device.unlockForConfiguration() }
                }
                
                try tuner.tune(device)
            } catch let error {
                errorHandler(error)
            }
        }
    }
    
    func run<T: AespaConnectionTuning>(_ tuner: T, _ errorHandler: @escaping ErrorHandler) {
        workQueue.async {
            do {
                guard let connection = self.connections.first else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try tuner.tune(connection)
            } catch let error {
                errorHandler(error)
            }
        }
    }
    
    func run<T: AespaMovieFileOutputProcessing>(_ processor: T, _ errorHandler: @escaping ErrorHandler) {
        workQueue.async {
            do {
                guard let output = self.movieFileOutput else {
                    throw AespaError.session(reason: .cannotFindConnection)
                }
                
                try processor.process(output)
            } catch let error {
                errorHandler(error)
            }
        }
    }
}
