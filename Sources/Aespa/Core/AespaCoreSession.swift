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
    
    init(option: AespaOption) {
        self.option = option
    }
    
    func run(_ tuner: some AespaSessionTuning) throws {
        if tuner.needTransaction { self.beginConfiguration() }
        defer {
            if tuner.needTransaction { self.commitConfiguration() }
        }
        
        try tuner.tune(self)
    }
    
    func run(_ tuner: some AespaDeviceTuning) throws {
        guard let device = self.videoDeviceInput?.device else {
            throw AespaError.device(reason: .invalid)
        }
        
        if tuner.needLock { try device.lockForConfiguration() }
        defer {
            if tuner.needLock { device.unlockForConfiguration() }
        }
        
        try tuner.tune(device)
    }
    
    func run(_ tuner: some AespaConnectionTuning) throws {
        guard let connection = self.connections.first else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        try tuner.tune(connection)
    }
    
    func run(_ processor: some AespaFileOutputProcessing) throws {
        guard let output = self.movieFileOutput else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        try processor.process(output)
    }
}
