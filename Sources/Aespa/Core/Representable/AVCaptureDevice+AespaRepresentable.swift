//
//  AespaCaptureDeviceRepresentable.swift
//  
//
//  Created by 이영빈 on 2023/06/16.
//

import Foundation
import AVFoundation

protocol AespaCaptureDeviceRepresentable {
    var focusMode: AVCaptureDevice.FocusMode { get set }
    var videoZoomFactor: CGFloat { get set }
    
    var maxResolution: Double? { get }
    
    func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool
    
    func setFocusMode(_ focusMode: AVCaptureDevice.FocusMode) throws
    func setZoomFactor(_ factor: CGFloat)
}

extension AVCaptureDevice: AespaCaptureDeviceRepresentable {
    func setFocusMode(_ focusMode: FocusMode) throws {
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
