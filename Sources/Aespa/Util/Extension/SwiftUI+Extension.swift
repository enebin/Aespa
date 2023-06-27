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
    /// This function is used to create a preview of the session.
    /// It returns a SwiftUI `View` that displays video as it is being captured.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    /// - Parameter position: Determines the initial position of the camera (front or back). Default is .back.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed.
    func preview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        startPosition position: AVCaptureDevice.Position = .back
    ) -> some View {
        return Preview(of: self, gravity: gravity)
    }
    
    /// This function is used to create an interactive preview of the session.
    /// It returns a SwiftUI `View` that not only displays video as it is being captured,
    /// but also allows user interaction like tap-to-focus, pinch zoom and double tap position change.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    /// - Parameter position: Determines the initial position of the camera (front or back). Default is .front.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed and allows user interaction.
    ///
    /// - Warning: Tap-to-focus works only in `autoFocus` mode.
    ///     Make sure you're using this mode for the feature to work.
    func interactivePreview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        startPosition position: AVCaptureDevice.Position = .front
    ) -> some View {
        let internalPreview = Preview(of: self, gravity: gravity)
        return InteractivePreview(internalPreview, startPosition: position)
    }
}

public struct InteractivePreview: View {
    private let preview: Preview
    private let animationQueue: OperationQueue
    // Position
    @State private var enableChangePosition = true
    @State private var cameraPosition: AVCaptureDevice.Position
    
    // Zoom
    @State private var enableZoom = true
    @State private var previousZoomFactor: CGFloat = 1.0
    @State private var currentZoomFactor: CGFloat = 1.0
    
    // Foocus
    @State private var enableFocus = true
    @State private var enableShowingCrosshair = true
    @State private var tappedLocation = CGPoint.zero
    @State private var focusFrameOpacity: Double = 0
    @State private var focusingTask: Task<Void, Error>?

    init(
        _ preview: Preview,
        startPosition: AVCaptureDevice.Position
    ) {
        self.preview = preview
        self.cameraPosition = startPosition
        self.animationQueue = OperationQueue()
        animationQueue.maxConcurrentOperationCount = 1
    }
    
    var session: AespaSession {
        preview.session
    }
    
    var layer: AVCaptureVideoPreviewLayer {
        preview.previewLayer
    }
    
    var currentFocusMode: AVCaptureDevice.FocusMode {
        session.currentFocusMode ?? .continuousAutoFocus
    }
    
    var currentCameraPosition: AVCaptureDevice.Position {
        session.currentCameraPosition ?? cameraPosition
    }
    
    public var body: some View {
        ZStack {
            preview
                .gesture(changePositionGesture)
                .gesture(tapToFocusGesture)
                .gesture(pinchZoomGesture)
            
            // Crosshair
            Rectangle()
                .stroke(lineWidth: 1)
                .foregroundColor(Color.yellow)
                .frame(width: 100, height: 100)
                .position(tappedLocation)
                .opacity(focusFrameOpacity)
                .animation(.spring(), value: focusFrameOpacity)
        }
    }
}

private extension InteractivePreview {
    var changePositionGesture: some Gesture {
        guard enableChangePosition else {
            return TapGesture(count: 2).onEnded{}
        }
        
        return TapGesture(count: 2).onEnded {
            let nextPosition: AVCaptureDevice.Position = (currentCameraPosition == .back) ? .front : .back
            session.setPosition(to: nextPosition)
            
            cameraPosition = nextPosition
        }
    }
    
    var tapToFocusGesture: some Gesture {
        guard enableFocus else {
            return DragGesture(minimumDistance: 0).onEnded{ _ in }
        }
        
        return DragGesture(minimumDistance: 0)
            .onEnded { value in
                guard enableFocus else { return }
                
                //                if currentFocusMode == .autoFocus {
                session.setFocus(mode: .autoFocus, point: value.location)
                tappedLocation = value.location
                
                showCrosshair()
                //                }
            }
    }
    
    var pinchZoomGesture: some Gesture {
        guard enableZoom else {
            return MagnificationGesture().onChanged { _ in } .onEnded { _ in }
        }
        
        let maxZoomFactor = session.maxZoomFactor ?? 1.0
        return MagnificationGesture()
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
    }
    
    func showCrosshair() {
        guard enableShowingCrosshair else { return }
        
        // Cancel the previous task
        focusingTask?.cancel()
        
        focusingTask = Task {
            withAnimation { focusFrameOpacity = 1 }
            
            // Sleep for 2 seconds
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            withAnimation { focusFrameOpacity = 0.35 }
            
            // Sleep for 3 more seconds
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            withAnimation { focusFrameOpacity = 0 }
        }
    }
}

public extension InteractivePreview {
    func crosshair(enabled: Bool) {
        enableShowingCrosshair = enabled
    }
    
    func tapToFocus(enabled: Bool) {
        enableFocus = enabled
    }
    
    func doubleTapToChangeCameraPosition(enabled: Bool) {
        enableChangePosition = enabled
    }
    
    func pinchZoom(enabled: Bool) {
        enableZoom = enabled
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
