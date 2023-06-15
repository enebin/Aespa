//
//  SwiftUI + Extension.swift
//  
//
//  Created by Young Bin on 2023/06/06.
//

import Combine
import SwiftUI
import AVFoundation

public extension AespaSession {
    /// A `SwiftUI` `View` that you use to display video as it is being captured by an input device.
    ///
    /// - Parameter gravity: Define `AVLayerVideoGravity` for preview's orientation. `.resizeAspectFill` by default.
    ///
    /// - Returns: `some UIViewRepresentable` which can coordinate other `View` components
    func preview(gravity: AVLayerVideoGravity = .resizeAspectFill) -> some UIViewControllerRepresentable {
        Preview(of: previewLayer, gravity: gravity)
    }
}

fileprivate struct Preview: UIViewControllerRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    let gravity: AVLayerVideoGravity

    init(
        of previewLayer: AVCaptureVideoPreviewLayer,
        gravity: AVLayerVideoGravity
    ) {
        self.gravity = gravity
        self.previewLayer = previewLayer
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        previewLayer.videoGravity = gravity
        uiViewController.view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = uiViewController.view.bounds
    }

    func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        previewLayer.removeFromSuperlayer()
    }
}
