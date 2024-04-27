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
        
        // Or you can give some options
//        let option = InteractivePreviewOption(enableZoom: true)
//        return aespaSession.interactivePreview(option: option)
    }
    
    private var subscription = Set<AnyCancellable>()
    
    @Published var videoAlbumCover: Image?
    @Published var photoAlbumCover: Image?
    
    @Published var videoFiles: [VideoAsset] = []
    @Published var photoFiles: [PhotoAsset] = []
    
    init() {
        // If you don't want to make an album, you can set `albumName` to `nil`
        let option = AespaOption(albumName: "YOUR_ALBUM_NAME")
        self.aespaSession = Aespa.session(with: option)

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
        
        // Photo-only setting
        aespaSession
            .photo(.flashMode(mode: .on))
            .photo(.redEyeReduction(enabled: true))

        // Video-only setting
        aespaSession
            .video(.mute)
            .video(.stabilization(mode: .auto))

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
        
        aespaSession.videoAssetEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                
                if case .deleted = event {
                    self.fetchVideoFiles()
                    
                    // It works, but not recommended
                    // videoFiles.remove(assets)
                    
                    // Update thumbnail
                    self.videoAlbumCover = self.videoFiles.first?.thumbnailImage
                }
            }
            .store(in: &subscription)

        aespaSession.photoAssetEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                
                if case .deleted = event {
                    self.fetchPhotoFiles()
                    
                    // It works, but not recommended
                    // photoFiles.remove(assets)
                    
                    // Update thumbnail
                    self.photoAlbumCover = self.photoFiles.first?.image
                }
            }
            .store(in: &subscription)
    }
    
    func fetchVideoFiles() {
        // File fetching task can cause low reponsiveness when called from main thread
        Task(priority: .utility) {
            let fetchedFiles = await aespaSession.fetchVideoFiles()
            DispatchQueue.main.async { self.videoFiles = fetchedFiles }
        }
    }
    
    func fetchPhotoFiles() {
        // File fetching task can cause low reponsiveness when called from main thread
        Task(priority: .utility) {
            let fetchedFiles = await aespaSession.fetchPhotoFiles()
            DispatchQueue.main.async { self.photoFiles = fetchedFiles }
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
