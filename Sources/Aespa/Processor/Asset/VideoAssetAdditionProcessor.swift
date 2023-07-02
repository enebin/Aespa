//
//  VideoAssetAdditionProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import Foundation

struct VideoAssetAdditionProcessor: AespaAssetProcessing {
    let filePath: URL

    func process<
        T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
    >(
        _ photoLibrary: T,
        _ assetCollection: U
    ) async throws {
        guard
            case .authorized = await photoLibrary.requestAuthorization(for: .addOnly)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            Logger.log(error: error)
            throw error
        }

        try await add(video: filePath, to: assetCollection, photoLibrary)
    }

    /// Add the video to the app's album roll
    func add<
        T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
    >(video path: URL,
      to album: U,
      _ photoLibrary: T
    ) async throws {
        guard album.canAdd(video: path) else {
            throw AespaError.album(reason: .notVideoURL)
        }

        return try await photoLibrary.performChanges {
            guard
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
                let placeholder = assetChangeRequest.placeholderForCreatedAsset,
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album.underlyingAssetCollection)
            else {
                Logger.log(error: AespaError.album(reason: .unabledToAccess))
                return
            }

            let enumeration = NSArray(object: placeholder)
            albumChangeRequest.addAssets(enumeration)
            
            Logger.log(message: "File is added to album")
        }
    }
}
