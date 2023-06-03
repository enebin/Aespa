//
//  ZoomTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct ZoomTuner: AespaDeviceInputTuning {
    var zoomFactor: CGFloat

    func tune(_ deviceInput: AVCaptureDeviceInput) {
        deviceInput.setZoomFactor(factor: zoomFactor)
    }
}
