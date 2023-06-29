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
    
    var preview: InteractivePreview {
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
        
        // Common setting
        aespaSession
            .focus(mode: .continuousAutoFocus)
            .changeMonitoring(enabled: true)
            .orientation(to: .portrait)
            .quality(to: .high)
            .custom(WideColorCameraTuner()) { result in
                if case .failure(let error) = result {
                    print("Error: ", error)
                }
            }
        
        // Photo-only setting
        aespaSession
            .flashMode(to: .on)
            .redEyeReduction(enabled: true)
        
        // Video-only setting
        aespaSession
            .mute()
            .stabilization(mode: .auto)
        
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
