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
    let isSubjectAreaChangeMonitoringEnabled: Bool
    
    let point: CGPoint? // Should be passed as original CGPoint, not mapped

    func tune<T: AespaCaptureDeviceRepresentable>(_ device: T) throws {
        guard device.isFocusModeSupported(mode) else {
            throw AespaError.device(reason: .unsupported)
        }
                
        var parsedPoint = point
        if let point {
            parsedPoint = CGPoint(
                x: point.x / UIScreen.main.bounds.width,
                y: point.y / UIScreen.main.bounds.height
            )
        }

        device.isSubjectAreaChangeMonitoringEnabled = isSubjectAreaChangeMonitoringEnabled
        device.setFocusMode(mode, point: parsedPoint)
    }
}
