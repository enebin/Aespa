//
//  ContentView.swift
//  ExampleCode
//
//  Created by ab180 on 11/29/23.
//

// EXAMPLE_CODE: SWIFTUI_INTEGRATION
import Aespa
import SwiftUI

struct VideoContentView: View {
    @StateObject private var viewModel = VideoContentViewModel()
    
    var body: some View {
        ZStack {
            viewModel.preview
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

class VideoContentViewModel: ObservableObject {
    let aespaSession: AespaSession
    var preview: some View {
        aespaSession.interactivePreview()
    }
    
    init() {
        let option = AespaOption(albumName: "YOUR_ALBUM_NAME")
        self.aespaSession = Aespa.session(with: option)
        
        setUp()
    }
    
    func setUp() {
        aespaSession
            .common(.quality(preset: .high))
        
        // Other options
        // ...
    }
}
// EXAMPLE_CODE: END

struct ExampleCodeView: View {
    @StateObject private var viewModel = VideoContentViewModel()
    var aespaSession: AespaSession {
        viewModel.aespaSession
    }
    
    var body: some View {
        ZStack {
            viewModel.preview
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            // EXAMPLE_CODE: RECORDING_AND_CAPTURE
            // Start recording
            aespaSession.startRecording()
            // Later... stop recording
            aespaSession.stopRecording()
            // Capture photo
            aespaSession.capturePhoto()
            // EXAMPLE_CODE: END
        }
        .onTapGesture {
            // EXAMPLE_CODE: GET_RESULT
            aespaSession.stopRecording { result in
                switch result {
                case .success(let file):
                    print(file.path) // file://some/path
                case .failure(let error):
                    print(error)
                }
            }
            
            // or...
            Task {
                let files = await aespaSession.fetchVideoFiles(limit: 1)
            }

            // or you can use publisher
            aespaSession.videoFilePublisher.sink { result in
                print(result)
            }
            // EXAMPLE_CODE: END
        }
    }
}

class ExampleCodeClass {
    let aespaSession: AespaSession
    
    init() {
        // EXAMPLE_CODE: GETTING_STARTED
        let option = AespaOption(albumName: "YOUR_ALBUM_NAME")
        self.aespaSession = Aespa.session(with: option)
        // EXAMPLE_CODE: END
        
        setUp()
    }
    
    func setUp() {
        // EXAMPLE_CODE: COMMON_SETTING
        // Common setting
        aespaSession
            .common(.focus(mode: .continuousAutoFocus))
            .common(.changeMonitoring(enabled: true))
            .common(.orientation(orientation: .portrait))
            .common(.quality(preset: .high))
            .common(.custom(tuner: WideColorCameraTuner())) { result in
                if case .failure(let error) = result {
                    print("Error: ", error)
                }
            }
        // EXAMPLE_CODE: END
        
        // EXAMPLE_CODE: PHOTO_SETTING
        // Photo-only setting
        aespaSession
            .photo(.flashMode(mode: .on))
            .photo(.redEyeReduction(enabled: true))
        // EXAMPLE_CODE: END

        // EXAMPLE_CODE: VIDEO_SETTING
        // Video-only setting
        aespaSession
            .video(.mute)
            .video(.stabilization(mode: .auto))
        // EXAMPLE_CODE: END
    }
}

struct WideColorCameraTuner: AespaSessionTuning {
    func tune<T>(_ session: T) throws where T : AespaCoreSessionRepresentable {
        session.avCaptureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
    }
}
