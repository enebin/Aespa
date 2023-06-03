//
//  AespaCoreAlbumManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import AVFoundation

/// Retreive the video(url) from `FileManager` based local storage and add the video to the pre-defined album roll
class AespaCoreAlbumManager {
    // Dependencies
    private let photoLibrary: PHPhotoLibrary
    private let albumName: String
    
    convenience init(albumName: String) {
        let photoLibrary = PHPhotoLibrary.shared()
        self.init(albumName: albumName, photoLibrary)
    }
    
    init(
        albumName: String,
        _ photoLibrary: PHPhotoLibrary
    ) {
        self.albumName = albumName
        self.photoLibrary = photoLibrary
    }
    
    func run(processor: some AespaAssetProcessing) async throws {
        let album = try AlbumImporter.getAlbum(name: albumName, in: photoLibrary)
        
        try await processor.process(photoLibrary, album)
    }
}

extension AespaCoreAlbumManager {
    func addToAlbum(filePath: URL) async throws {
        let processor = AssetAdditionProcessor(filePath: filePath)
        try await run(processor: processor)
    }
}
