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
    
    func tune(_ session: AVCaptureSession) throws {
        try session.setCameraPosition(to: position)
    }
}

