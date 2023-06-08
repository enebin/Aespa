//
//  QualityTuner.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct QualityTuner: AespaSessionTuning {
    let needTransaction = true
    var videoQuality: AVCaptureSession.Preset // default zoom factor

    func tune(_ session: some AespaCoreSessionRepresentable) {
        session.setVideoQuality(to: self.videoQuality)
    }
}
