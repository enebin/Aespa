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
    /// This function is used to create a preview of the session. Doesn't offer any functionalities.
    /// It returns a SwiftUI `View` that displays video as it is being captured.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed.
    func preview(gravity: AVLayerVideoGravity = .resizeAspectFill) -> some View {
        return Preview(of: self, gravity: gravity)
    }
    
    /// This function is used to create an interactive preview of the session.
    /// It returns a SwiftUI `View` that not only displays video as it is being captured,
    /// but also allows user interaction like tap-to-focus, pinch zoom and double tap position change.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed and allows user interaction.
    ///
    /// - Warning: Tap-to-focus works only in `autoFocus` mode.
    ///     Make sure you're using this mode for the feature to work.
    func interactivePreview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        prefereedFocusMode focusMode: AVCaptureDevice.FocusMode = .continuousAutoFocus
    ) -> InteractivePreview {
        let internalPreview = Preview(of: self, gravity: gravity)
        return InteractivePreview(internalPreview, preferredFocusMode: focusMode)
    }
}

public struct InteractivePreview: View {
    private let preview: Preview

    // Position
    @State private var enableChangePosition = true
    
    // Zoom
    @State private var enableZoom = true
    @State private var previousZoomFactor: CGFloat = 1.0
    @State private var currentZoomFactor: CGFloat = 1.0
    
    // Foocus
    @State private var preferredFocusMode: AVCaptureDevice.FocusMode = .continuousAutoFocus
    @State private var enableFocus = true
    @State private var focusingLocation = CGPoint.zero
    // Crosshair
    @State private var enableShowingCrosshair = true
    @State private var focusFrameOpacity: Double = 0
    @State private var showingCrosshairTask: Task<Void, Error>?
    
    var subjectAreaChangeMonitoringSubscription: Cancellable?
    
    init(_ preview: Preview, preferredFocusMode focusMode: AVCaptureDevice.FocusMode) {
        self.preview = preview
        self.preferredFocusMode = focusMode
        self.subjectAreaChangeMonitoringSubscription = preview
            .session
            .getSubjectAreaDidChangePublisher()
            .sink(receiveValue: { [self] _ in
                self.resetFocusMode(to: focusMode)
            })
    }
    
    var session: AespaSession {
        preview.session
    }
    
    var layer: AVCaptureVideoPreviewLayer {
        preview.previewLayer
    }
    
    var currentFocusMode: AVCaptureDevice.FocusMode? {
        session.currentFocusMode
    }
    
    var currentCameraPosition: AVCaptureDevice.Position? {
        session.currentCameraPosition
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
                .position(focusingLocation)
                .opacity(focusFrameOpacity)
                .animation(.spring(), value: focusFrameOpacity)
        }
    }
}

private extension InteractivePreview {
    var changePositionGesture: some Gesture {
        guard session.isRunning, enableChangePosition else {
            return TapGesture(count: 2).onEnded{}
        }
        
        return TapGesture(count: 2).onEnded {
            let nextPosition: AVCaptureDevice.Position = (currentCameraPosition == .back) ? .front : .back
            session.position(to: nextPosition)
        }
    }
    
    var tapToFocusGesture: some Gesture {
        guard session.isRunning, enableFocus else {
            return DragGesture(minimumDistance: 0).onEnded{ _ in }
        }
        
        return DragGesture(minimumDistance: 0)
            .onEnded { value in
                guard
                    let currentFocusMode,
                    currentFocusMode == .autoFocus || currentFocusMode == .continuousAutoFocus
                else {
                    return
                }
                
                session.focus(mode: currentFocusMode, point: value.location)
                focusingLocation = value.location
                
                if enableShowingCrosshair {
                    showCrosshair()
                }
            }
    }
    
    var pinchZoomGesture: some Gesture {
        guard session.isRunning, enableZoom else {
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
    
    func resetFocusMode(to focusMode: AVCaptureDevice.FocusMode) {
        guard session.isRunning else { return }
        session.focus(mode: focusMode)
    }
    
    func showCrosshair() {
        guard enableShowingCrosshair else { return }
        
        // Cancel the previous task
        showingCrosshairTask?.cancel()
        // Running a new task
        showingCrosshairTask = Task {
            // 10^9 nano seconds = 1 second
            let second: UInt64 = 1_000_000_000
            
            withAnimation { focusFrameOpacity = 1 }
            
            try await Task.sleep(nanoseconds: 2 * second)
            withAnimation { focusFrameOpacity = 0.35 }
            
            try await Task.sleep(nanoseconds: 3 * second)
            withAnimation { focusFrameOpacity = 0 }
        }
    }
}

public extension InteractivePreview {
    func crosshair(enabled: Bool) -> Self {
        enableShowingCrosshair = enabled
        return self
    }
    
    func tapToFocus(enabled: Bool) -> Self {
        enableFocus = enabled
        return self
    }
    
    func preferredFocusMode(_ mode: AVCaptureDevice.FocusMode) -> Self {
        preferredFocusMode = mode
        return self
    }
    
    func doubleTapToChangeCameraPosition(enabled: Bool) -> Self {
        enableChangePosition = enabled
        return self
    }
    
    func pinchZoom(enabled: Bool) -> Self {
        enableZoom = enabled
        return self
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
