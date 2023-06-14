//
//  CameraPositionTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct CameraPositionTuner: AespaSessionTuning {
    let needTransaction = true
    var position: AVCaptureDevice.Position
    var devicePreference: AVCaptureDevice.DeviceType?
    
    init(position: AVCaptureDevice.Position, devicePreference: AVCaptureDevice.DeviceType? = nil) {
        self.position = position
        self.devicePreference = devicePreference
    }
    
    func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws {
        try session.setCameraPosition(to: position, device: devicePreference)
    }
}

