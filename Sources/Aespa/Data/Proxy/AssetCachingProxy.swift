//
//  AssetCachingProxy.swift
//  
//
//  Created by 이영빈 on 2023/07/02.
//

import UIKit
import AVFoundation
import Photos

struct AssetCachingProxy {
    private let assetManager: PHCachingImageManager
    
    init(_ assetManager: PHCachingImageManager = .init()) {
        self.assetManager = assetManager
    }

    // Fetch videos using async/await
    func fetchVideo(_ assets: [PHAsset]) async -> [VideoAsset] {
        var assetFiles: [VideoAsset] = []
        
        await withTaskGroup(of: VideoAsset?.self) { group in
            for asset in assets {
                group.addTask(priority: .utility) {
                    let option = PHVideoRequestOptions()
                    
                    option.version = .original
                    option.deliveryMode = .automatic
                    option.isNetworkAccessAllowed = true
                    
                    let avAsset = await self.requestAVAsset(forVideo: asset, options: option)
                    
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.deliveryMode = .opportunistic
                    requestOptions.isNetworkAccessAllowed = true
                    requestOptions.resizeMode = .exact
                    requestOptions.isSynchronous = true
                    
                    let image = await self.requestImage(
                        for: asset,
                        targetSize: .init(
                            width: PHImageManagerMaximumSize.width,
                            height: PHImageManagerMaximumSize.height),
                        contentMode: .default,
                        options: requestOptions
                    )
                    
                    if let avAsset {
                        return VideoAsset(phAsset: asset, asset: avAsset, thumbnail: image ?? UIImage())
                    } else {
                        return nil
                    }
                }
            }

            for await assetFile in group {
                if let assetFile { assetFiles.append(assetFile) }
            }
        }

        return assetFiles.sorted()
    }
    
    // Fetch photos using async/await
    func fetchPhoto(_ assets: [PHAsset]) async -> [PhotoAsset] {
        var assetFiles: [PhotoAsset] = []

        await withTaskGroup(of: PhotoAsset?.self) { group in
            for asset in assets {
                group.addTask(priority: .utility) {
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.deliveryMode = .opportunistic
                    requestOptions.isNetworkAccessAllowed = true
                    requestOptions.resizeMode = .exact
                    requestOptions.isSynchronous = true
                    
                    let image = await self.requestImage(
                        for: asset,
                        targetSize: PHImageManagerMaximumSize,
                        contentMode: .default,
                        options: requestOptions
                    )
                    
                    if let image {
                        return PhotoAsset(asset: asset, uiimage: image)
                    } else {
                        return nil
                    }
                }
            }
        
            for await assetFile in group {
                if let assetFile { assetFiles.append(assetFile) }
            }
        }
        
        return assetFiles.sorted()
    }
}

private extension AssetCachingProxy {
    // Create custom async function to fetch AVAsset
    func requestAVAsset(
        forVideo asset: PHAsset,
        options: PHVideoRequestOptions
    ) async -> AVAsset? {
        return await withCheckedContinuation { continuation in
            assetManager.requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
                continuation.resume(returning: avAsset)
            }
        }
    }

    // Create custom async function to fetch thumbnail
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions
    ) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            assetManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
}
