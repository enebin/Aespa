//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/16.
//

import Foundation
import AVFoundation

protocol AespaCaptureConnectionRepresentable {
    var videoOrientation: AVCaptureVideoOrientation { get set }
    var preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode { get set }
    
    func setOrientation(to orientation: AVCaptureVideoOrientation)
    func setStabilizationMode(to mode: AVCaptureVideoStabilizationMode)
}

extension AVCaptureConnection: AespaCaptureConnectionRepresentable {
    func setOrientation(to orientation: AVCaptureVideoOrientation) {
        self.videoOrientation = orientation
    }
    
    func setStabilizationMode(to mode: AVCaptureVideoStabilizationMode) {
        self.preferredVideoStabilizationMode = mode
    }
}

