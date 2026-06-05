//
//  UIKit + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import UIKit
import AVFoundation

nonisolated extension UIDeviceOrientation {
    var toVideoOrientation: AVCaptureVideoOrientation {
        let previewOrientation: AVCaptureVideoOrientation

        switch self {
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

        return previewOrientation
    }
}

nonisolated enum DeviceOrientationProvider {
    static var currentVideoOrientation: AVCaptureVideoOrientation {
        if Thread.isMainThread {
            return MainActor.assumeIsolated {
                UIDevice.current.orientation.toVideoOrientation
            }
        }

        return DispatchQueue.main.sync {
            MainActor.assumeIsolated {
                UIDevice.current.orientation.toVideoOrientation
            }
        }
    }
}
