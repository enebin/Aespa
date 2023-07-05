//
//  AespaCoreAlbumManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos

/// Retreive the video(url) from `FileManager` based local storage
/// and add the video to the pre-defined album roll
class AespaCoreAlbumManager {
    // Dependencies
    private let photoLibrary: PHPhotoLibrary
    private let albumName: String
    private var album: PHAssetCollection?

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

    func run<T: AespaAssetProcessing>(processor: T) async throws {
        if let album {
            try await processor.process(photoLibrary, album)
        } else {
            album = try AlbumImporter.getAlbum(name: albumName, in: photoLibrary)
            try await run(processor: processor)
        }
    }
}

extension AespaCoreAlbumManager {
    func addToAlbum(asset: PHObject) async throws {
        let processor = AssetAdditionProcessor(asset: asset)
        try await run(processor: processor)
    }
}
