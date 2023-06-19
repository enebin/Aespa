//
//  PhotoAssetAdditionProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/19.
//

import Photos
import Foundation

struct PhotoAssetAdditionProcessor: AespaAssetProcessing {
    let imageData: Data

    func process<T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable>(_ photoLibrary: T, _ assetCollection: U) async throws {
        guard
            case .authorized = await photoLibrary.requestAuthorization(for: .addOnly)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            Logger.log(error: error)
            throw error
        }

        try await add(imageData: imageData, to: assetCollection, photoLibrary)
        Logger.log(message: "File is added to album")
    }

    /// Add the video to the app's album roll
    func add<T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable>(imageData: Data, to album: U, _ photoLibrary: T) async throws -> Void {
        try await photoLibrary.performChanges {
            // Request creating an asset from the image.
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }
    }
}
