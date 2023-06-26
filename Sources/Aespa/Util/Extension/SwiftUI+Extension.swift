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
    /// - Parameter gravity: Define `AVLayerVideoGravity` for preview's orientation.
    ///     .resizeAspectFill` by default.
    ///
    /// - Returns: `some UIViewRepresentable` which can coordinate other `View` components
    func preview(
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
    
    @GestureState private var magnification: CGFloat = 1.0
    
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
    
    public var body: some View {
        preview
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if currentFocusMode == .autoFocus {
                        session.setFocus(mode: .autoFocus, point: value.location)
                    }
                })
            .onTapGesture(count: 2) {
                let nextPosition: AVCaptureDevice.Position = cameraPosition == .back ? .front : .back
                session.setPosition(to: nextPosition)
            }
            .gesture(MagnificationGesture()
                .updating($magnification) { currentState, gestureState, _ in
                    gestureState = currentState
                    session.zoom(factor: gestureState)
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
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session.avCaptureSession)
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
