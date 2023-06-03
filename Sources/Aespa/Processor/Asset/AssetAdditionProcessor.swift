//
//  AssetAddingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import Foundation

struct AssetAdditionProcessor: AespaAssetProcessing {
    let filePath: URL
    
    func process(_ photoLibrary: PHPhotoLibrary, _ assetCollection: PHAssetCollection) async throws {
        guard
            case .authorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            Logger.log(error: error)
            throw error
        }
        
        let album = assetCollection
        try await add(video: filePath, to: album, photoLibrary)
    }

    /// Add the video to the app's album roll
    func add(video path: URL, to album: PHAssetCollection, _ photoLibrary: PHPhotoLibrary) async throws -> Void {
        return try await photoLibrary.performChanges {
            if
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
                let placeholder = assetChangeRequest.placeholderForCreatedAsset
            {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration = NSArray(object: placeholder)
                
                albumChangeRequest?.addAssets(enumeration)
            }
        }
    }
}
