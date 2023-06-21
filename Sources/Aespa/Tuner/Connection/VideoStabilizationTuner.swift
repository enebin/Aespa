//
//  VideoStabilizationTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct VideoStabilizationTuner: AespaConnectionTuning {
    var stabilzationMode: AVCaptureVideoStabilizationMode

    func tune<T: AespaCaptureConnectionRepresentable>(_ connection: T) {
        connection.setStabilizationMode(to: stabilzationMode)
    }
}
