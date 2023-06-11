//
//  AVFoundation + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/28.
//

import AVFoundation

extension AVCaptureConnection {
    func setOrientation(to orientation: AVCaptureVideoOrientation) {
        self.videoOrientation = orientation
    }
    
    func setStabilizationMode(to mode: AVCaptureVideoStabilizationMode) {
        self.preferredVideoStabilizationMode = mode
    }
}

extension AVCaptureDevice.Position {
    var chooseBestCamera: AVCaptureDevice? {
        let position = self
        
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: position) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            return device
        } else {
            return nil
        }
    }
}

extension AVCaptureDevice {
    func setZoomFactor(factor: CGFloat) {
        let device = self

        do {
            try device.lockForConfiguration()

            device.videoZoomFactor = factor

            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
    }
}
