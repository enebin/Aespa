//
//  AutoFocusTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import Foundation
import AVFoundation

struct AutoFocusTuner: AespaDeviceTuning {
    let needLock = true
    let mode: AVCaptureDevice.FocusMode
    
    func tune<T: AespaCaptureDeviceRepresentable>(_ device: T) throws {
        guard device.isFocusModeSupported(mode) else {
            throw AespaError.device(reason: .unsupported)
        }
        
        device.setFocusMode(mode)
    }
}
