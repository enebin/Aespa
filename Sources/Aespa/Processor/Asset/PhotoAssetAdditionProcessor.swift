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

    func process<
        Library: AespaAssetLibraryRepresentable, Collection: AespaAssetCollectionRepresentable
    >(
        _ photoLibrary: Library,
        _ assetCollection: Collection
    ) async throws {
        guard
            case .authorized = await photoLibrary.requestAuthorization(for: .addOnly)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            Logger.log(error: error)
            throw error
        }

        try await add(imageData: imageData, to: assetCollection, photoLibrary)
    }
    
    /// Add the photo to the app's album roll
    func add<
        T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
    >(
        imageData: Data,
        to album: U,
        _ photoLibrary: T
    ) async throws {
        return try await photoLibrary.performChanges {
            // Request creating an asset from the image.
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
            
            // Add the asset to the desired album.
            guard
                let placeholder = creationRequest.placeholderForCreatedAsset,
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album.underlyingAssetCollection)
            else {
                Logger.log(error: AespaError.album(reason: .unabledToAccess))
                return
            }
            
            let enumeration = NSArray(object: placeholder)
            albumChangeRequest.addAssets(enumeration)
            
            Logger.log(message: "Photo is added to album")
        }
    }
}
