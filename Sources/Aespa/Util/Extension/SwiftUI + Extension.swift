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
    func preview(gravity: AVLayerVideoGravity = .resizeAspectFill) -> some UIViewRepresentable {
        AespaSwiftUIPreview(with: previewLayerPublisher, gravity: gravity)
    }
}

fileprivate struct AespaSwiftUIPreview: UIViewRepresentable {
    @StateObject var viewModel: AespaSwiftUIPreviewViewModel
    let gravity: AVLayerVideoGravity

    init(
        with publisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never>,
        gravity: AVLayerVideoGravity
    ) {
        _viewModel = StateObject(
            wrappedValue: AespaSwiftUIPreviewViewModel(previewLayerPublisher: publisher))
        self.gravity = gravity
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewLayer = viewModel.previewLayer else { return }
        
        previewLayer.videoGravity = gravity
        uiView.layer.addSublayer(previewLayer)
        
        previewLayer.frame = uiView.bounds
    }
}

fileprivate class AespaSwiftUIPreviewViewModel: ObservableObject {
    var subscription: Cancellable?
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(previewLayerPublisher: AnyPublisher<AVCaptureVideoPreviewLayer, Never>) {
        subscription = previewLayerPublisher
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { self.previewLayer = $0 }
    }
}
