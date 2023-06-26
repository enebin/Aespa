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
    func preview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        startPosition position: AVCaptureDevice.Position = .back,
        preferredFocusMode mode: AVCaptureDevice.FocusMode = .continuousAutoFocus
    ) -> some View {
        let internalPreview = Preview(of: self, gravity: gravity)
        return InteractivePreview(internalPreview, startPosition: position, preferredFocusMode: mode)
    }
    
    /// A `SwiftUI` `View` that you use to display video as it is being captured by an input device.
    ///
    /// - Parameter gravity: Define `AVLayerVideoGravity` for preview's orientation.
    ///     .resizeAspectFill` by default.
    ///
    /// - Returns: `some UIViewRepresentable` which can coordinate other `View` components
    func interactivePreview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        startPosition position: AVCaptureDevice.Position = .front,
        preferredFocusMode mode: AVCaptureDevice.FocusMode = .continuousAutoFocus
    ) -> some View {
        let internalPreview = Preview(of: self, gravity: gravity)
        return InteractivePreview(internalPreview, startPosition: position, preferredFocusMode: mode)
    }
}

public struct InteractivePreview: View {
    private let preview: Preview
    private let preferredFocusMode: AVCaptureDevice.FocusMode
    @State private var cameraPosition: AVCaptureDevice.Position
    
    @State private var previousZoomFactor: CGFloat = 1.0
    @State private var currentZoomFactor: CGFloat = 1.0

    init(
        _ preview: Preview,
        startPosition: AVCaptureDevice.Position,
        preferredFocusMode: AVCaptureDevice.FocusMode
    ) {
        self.preview = preview
        self.cameraPosition = startPosition
        self.preferredFocusMode = preferredFocusMode
    }
    
    var session: AespaSession {
        preview.session
    }
    
    var layer: AVCaptureVideoPreviewLayer {
        preview.previewLayer
    }
    
    var currentFocusMode: AVCaptureDevice.FocusMode {
        session.currentFocusMode ?? preferredFocusMode
    }
    
    var currentCameraPosition: AVCaptureDevice.Position {
        session.currentCameraPosition ?? cameraPosition
    }
    
    public var body: some View {
        let maxZoomFactor = session.maxZoomFactor ?? 1.0

        preview
            .onTapGesture(count: 2) {
                let nextPosition: AVCaptureDevice.Position = (currentCameraPosition == .back) ? .front : .back
                session.setPosition(to: nextPosition)
                cameraPosition = nextPosition
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if currentFocusMode == .autoFocus {
                        session.setFocus(mode: .autoFocus, point: value.location)
                    }
                })
            .gesture(MagnificationGesture()
                .onChanged { (scale) in
                    let videoZoomFactor = scale * previousZoomFactor
                    if (videoZoomFactor <= maxZoomFactor) {
                        let newZoomFactor = max(1.0, min(videoZoomFactor, maxZoomFactor))
                        session.zoom(factor: newZoomFactor)
                    }
                }
                .onEnded { (scale) in
                    let videoZoomFactor = scale * previousZoomFactor
                    previousZoomFactor = videoZoomFactor >= 1 ? videoZoomFactor : 1
                }
            )
    }
}

struct Preview: UIViewControllerRepresentable {
    let session: AespaSession
    let gravity: AVLayerVideoGravity
    let previewLayer: AVCaptureVideoPreviewLayer

    init(
        of session: AespaSession,
        gravity: AVLayerVideoGravity
    ) {
        self.gravity = gravity
        self.session = session
        self.previewLayer = session.previewLayer
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
