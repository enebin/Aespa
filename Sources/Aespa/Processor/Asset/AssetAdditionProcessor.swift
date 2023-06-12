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
            case .authorized = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            Logger.log(error: error)
            throw error
        }
        
        let album = assetCollection
        try await add(video: filePath, to: album, photoLibrary)
        Logger.log(message: "File is added to album")
    }

    /// Add the video to the app's album roll
    func add(video path: URL, to album: PHAssetCollection, _ photoLibrary: PHPhotoLibrary) async throws -> Void {
        func isVideo(fileUrl: URL) -> Bool {
            let asset = AVAsset(url: fileUrl)
            let tracks = asset.tracks(withMediaType: AVMediaType.video)

            return !tracks.isEmpty
        }
        
        print(isVideo(fileUrl: path))
        
        return try await photoLibrary.performChanges {
            guard
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
                let placeholder = assetChangeRequest.placeholderForCreatedAsset,
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            else {
                Logger.log(error: AespaError.album(reason: .unabledToAccess))
                return
            }
            
            let enumeration = NSArray(object: placeholder)
            albumChangeRequest.addAssets(enumeration)
        }
    }
}
