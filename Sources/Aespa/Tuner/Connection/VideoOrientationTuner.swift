//
//  VideoOrientationTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct VideoOrientationTuner: AespaConnectionTuning {
    var orientation: AVCaptureVideoOrientation
    
    func tune(_ connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
    }
}
