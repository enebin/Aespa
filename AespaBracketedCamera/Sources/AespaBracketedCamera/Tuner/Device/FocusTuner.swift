//
//  FocusTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import UIKit
import Foundation
import AVFoundation

struct FocusTuner: AespaDeviceTuning {
    let needLock = true
    
    let mode: AVCaptureDevice.FocusMode
    let point: CGPoint?

    func tune<T: AespaCaptureDeviceRepresentable>(_ device: T) throws {
        guard device.isFocusModeSupported(mode) else {
            throw AespaError.device(reason: .notSupported)
        }

        try device.setFocusMode(mode, point: point)
    }
}
