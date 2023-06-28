//
//  AespaCaptureDeviceRepresentable.swift
//  
//
//  Created by 이영빈 on 2023/06/16.
//

import Foundation
import AVFoundation

protocol AespaCaptureDeviceRepresentable: NSObject {
    var hasTorch: Bool { get }
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var isSubjectAreaChangeMonitoringEnabled: Bool { get set }
    var flashMode: AVCaptureDevice.FlashMode { get set }
    var videoZoomFactor: CGFloat { get set }

    var maxResolution: Double? { get }
    
    func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool

    func zoomFactor(_ factor: CGFloat)
    func focusMode(_ focusMode: AVCaptureDevice.FocusMode, point: CGPoint?)
    func torchMode(_ torchMode: AVCaptureDevice.TorchMode)
    func setTorchModeOn(level torchLevel: Float) throws
}

extension AVCaptureDevice: AespaCaptureDeviceRepresentable {
    func torchMode(_ torchMode: TorchMode) {
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

    func focusMode(_ focusMode: AVCaptureDevice.FocusMode, point: CGPoint?) {
        self.focusMode = focusMode
        if let point {
            self.focusPointOfInterest = point
        }
    }

    func zoomFactor(_ factor: CGFloat) {
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
