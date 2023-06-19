//
//  AespaCaptureDeviceRepresentable.swift
//  
//
//  Created by 이영빈 on 2023/06/16.
//

import Foundation
import AVFoundation

protocol AespaCaptureDeviceRepresentable {
    var hasTorch: Bool { get }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var flashMode: AVCaptureDevice.FlashMode { get set }
    var videoZoomFactor: CGFloat { get set }

    var maxResolution: Double? { get }

    func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool

    func setZoomFactor(_ factor: CGFloat)
    func setFocusMode(_ focusMode: AVCaptureDevice.FocusMode)
    func setTorchMode(_ torchMode: AVCaptureDevice.TorchMode)
    func setTorchModeOn(level torchLevel: Float) throws
}

extension AVCaptureDevice: AespaCaptureDeviceRepresentable {
    func setTorchMode(_ torchMode: TorchMode) {
        switch torchMode {
        case .off:
            self.torchMode = .off
        case .on:
            self.torchMode = .on
        case .auto:
            self.torchMode = .auto
        @unknown default:
            self.torchMode = .off
        }
    }

    func setFocusMode(_ focusMode: FocusMode) {
        self.focusMode = focusMode
    }

    func setZoomFactor(_ factor: CGFloat) {
        self.videoZoomFactor = factor
    }

    var maxResolution: Double? {
        var maxResolution: Double = 0
        for format in self.formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let resolution = Double(dimensions.width * dimensions.height)
            maxResolution = max(resolution, maxResolution)
        }
        return maxResolution
    }
}
