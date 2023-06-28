//
//  ChangeMonitoringTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/28.
//

import Foundation
import AVFoundation

struct ChangeMonitoringTuner: AespaDeviceTuning {
    let needLock = true
    
    let enabled: Bool
    
    init(isSubjectAreaChangeMonitoringEnabled: Bool) {
        self.enabled = isSubjectAreaChangeMonitoringEnabled
    }

    func tune<T: AespaCaptureDeviceRepresentable>(_ device: T) throws {
        device.isSubjectAreaChangeMonitoringEnabled = enabled
    }
}
