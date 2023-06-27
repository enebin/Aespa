//
//  VideoContentViewModel.swift
//  Aespa-iOS
//
//  Created by 이영빈 on 2023/06/07.
//

import Combine
import SwiftUI
import Foundation

import Aespa

class VideoContentViewModel: ObservableObject {
    let aespaSession: AespaSession
    
    var preview: some View {
        aespaSession.interactivePreview()
    }
    
    private var subscription = Set<AnyCancellable>()
    
    @Published var videoAlbumCover: Image?
    @Published var photoAlbumCover: Image?
    
    @Published var videoFiles: [VideoFile] = []
    @Published var photoFiles: [PhotoFile] = []
    
    init() {
        let option = AespaOption(albumName: "Aespa-Demo")
        self.aespaSession = Aespa.session(with: option)
        
        Task(priority: .background) {
            do {
                try await Aespa.configure()
                
                // Common setting
                aespaSession
                    .setFocus(mode: .continuousAutoFocus)
                    .setOrientation(to: .portrait)
                    .setQuality(to: .high)
                    .custom(WideColorCameraTuner())
                
                // Photo-only setting
                aespaSession
                    .setFlashMode(to: .on)
                    .redEyeReduction(enabled: true)
                
                // Video-only setting
                aespaSession
                    .mute()
                    .setStabilization(mode: .auto)
                
                // Prepare video album cover
                aespaSession.videoFilePublisher
                    .receive(on: DispatchQueue.main)
                    .map { result -> Image? in
                        if case .success(let file) = result {
                            return file.thumbnailImage
                        } else {
                            return nil
                        }
                    }
                    .assign(to: \.videoAlbumCover, on: self)
                    .store(in: &subscription)
                
                // Prepare photo album cover
                aespaSession.photoFilePublisher
                    .receive(on: DispatchQueue.main)
                    .map { result -> Image? in
                        if case .success(let file) = result {
                            return file.thumbnailImage
                        } else {
                            return nil
                        }
                    }
                    .assign(to: \.photoAlbumCover, on: self)
                    .store(in: &subscription)
                
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchVideoFiles() {
        // File fetching task can cause low reponsiveness when called from main thread
        DispatchQueue.global().async {
            let fetchedFiles = self.aespaSession.fetchVideoFiles()
            
            DispatchQueue.main.async {
                self.videoFiles = fetchedFiles
            }
        }
    }
    
    func fetchPhotoFiles() {
        // File fetching task can cause low reponsiveness when called from main thread
        DispatchQueue.global().async {
            let fetchedFiles = self.aespaSession.fetchPhotoFiles()
            
            DispatchQueue.main.async {
                self.photoFiles = fetchedFiles
            }
        }
    }
}


extension VideoContentViewModel {
    // Example for using custom session tuner
    struct WideColorCameraTuner: AespaSessionTuning {
        func tune<T>(_ session: T) throws where T : AespaCoreSessionRepresentable {
            session.avCaptureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
        }
    }
}
