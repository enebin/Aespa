//
//  TorchTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/17.
//

import Foundation
import AVFoundation

struct TorchTuner: AespaDeviceTuning {
    let level: Float
    let torchMode: AVCaptureDevice.TorchMode

    func tune<T>(_ device: T) throws where T: AespaCaptureDeviceRepresentable {
        guard device.hasTorch else {
            throw AespaError.device(reason: .unsupported)
        }

        device.setTorchMode(torchMode)
        try device.setTorchModeOn(level: level)
    }
}
