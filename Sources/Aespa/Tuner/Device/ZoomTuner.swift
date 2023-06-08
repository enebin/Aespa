//
//  ZoomTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct ZoomTuner: AespaDeviceTuning {
    var needLock = true
    var zoomFactor: CGFloat

    func tune(_ device: AVCaptureDevice) {
        device.setZoomFactor(factor: zoomFactor)
    }
}
