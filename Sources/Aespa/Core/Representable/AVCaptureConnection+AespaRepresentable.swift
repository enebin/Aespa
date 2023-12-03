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
    var isVideoOrientationSupported: Bool { get }

    func orientation(to orientation: AVCaptureVideoOrientation)
    func stabilizationMode(to mode: AVCaptureVideoStabilizationMode)
}

extension AVCaptureConnection: AespaCaptureConnectionRepresentable {
    func orientation(to orientation: AVCaptureVideoOrientation) {
        self.videoOrientation = orientation
    }

    func stabilizationMode(to mode: AVCaptureVideoStabilizationMode) {
        self.preferredVideoStabilizationMode = mode
    }
}
