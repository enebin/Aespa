//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

#if canImport(UIKit)
import UIKit
import AVFoundation

extension UIDeviceOrientation {
    var toVideoOrientation: AVCaptureVideoOrientation {
        let currentOrientation = UIDevice.current.orientation
        let previewOrientation: AVCaptureVideoOrientation
        
        switch currentOrientation {
        case .portrait:
            previewOrientation = .portrait
        case .portraitUpsideDown:
            previewOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewOrientation = .landscapeRight
        case .landscapeRight:
            previewOrientation = .landscapeLeft
        default:
            previewOrientation = .portrait
        }
        
        print(previewOrientation.rawValue)
        
        return previewOrientation
    }
}
#endif
