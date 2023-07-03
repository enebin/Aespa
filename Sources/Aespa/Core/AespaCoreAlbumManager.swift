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
    private let cachingProxy: AssetCachingProxy
    private let photoLibrary: PHPhotoLibrary
    private let albumName: String
    private var album: PHAssetCollection?

    convenience init(albumName: String) {
        let photoLibrary = PHPhotoLibrary.shared()
        let cachingProxy = AssetCachingProxy()
        self.init(albumName: albumName, cachingProxy, photoLibrary)
    }

    init(
        albumName: String,
        _ cachingProxy: AssetCachingProxy,
        _ photoLibrary: PHPhotoLibrary
    ) {
        self.cachingProxy = cachingProxy
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
    
    func run<T: AespaAssetLoading>(loader: T) throws -> T.ReturnType {
        if let album {
            return try loader.load(photoLibrary, album)
        } else {
            album = try AlbumImporter.getAlbum(name: albumName, in: photoLibrary)
            return try run(loader: loader)
        }
    }
}

extension AespaCoreAlbumManager {
    func addToAlbum(filePath: URL) async throws {
        let processor = VideoAssetAdditionProcessor(filePath: filePath)
        try await run(processor: processor)
    }

    func addToAlbum(imageData: Data) async throws {
        let processor = PhotoAssetAdditionProcessor(imageData: imageData)
        try await run(processor: processor)
    }
    
    func fetchPhotoFile(limit: Int) async throws -> [PhotoAssetFile] {
        let processor = AssetLoader(limit: limit, assetType: .image)
        let assets = try run(loader: processor)
        
        return await cachingProxy.fetchPhoto(assets)
    }
    
    func fetchVideoFile(limit: Int) async throws -> [VideoAssetFile] {
        let processor = AssetLoader(limit: limit, assetType: .video)
        let assets = try run(loader: processor)
        
        return await cachingProxy.fetchVideo(assets)
    }
}

struct AssetLoader: AespaAssetLoading {
    let limit: Int
    let assetType: PHAssetMediaType
    
    func load<
        Library: AespaAssetLibraryRepresentable, Collection: AespaAssetCollectionRepresentable
    >(
        _ photoLibrary: Library,
        _ assetCollection: Collection
    ) throws -> [PHAsset] {
        let videoFetchOptions = PHFetchOptions()
        videoFetchOptions.fetchLimit = limit
        videoFetchOptions.predicate = NSPredicate(format: "mediaType = %d", assetType.rawValue)
        
        guard let assetCollection = assetCollection as? PHAssetCollection else {
            fatalError("Asset collection doesn't conform to PHAssetCollection")
        }

        var assets = [PHAsset]()
        let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: videoFetchOptions)
        assetsFetchResult.enumerateObjects { (asset, index, stop) in
            assets.append(asset)
        }
        
        return assets
    }
}
