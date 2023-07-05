//
//  AssetAdditionProcessor.swift
//  
//
//  Created by 이영빈 on 2023/07/05.
//

import Photos
import Foundation


struct AssetAdditionProcessor: AespaAssetProcessing {
    let asset: PHObject

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

        try await add(asset, to: assetCollection, photoLibrary)
    }

    /// Add the file to the app's album roll
    func add<
        T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
    >(
        _ asset: PHObject,
        to album: U,
        _ photoLibrary: T
    ) async throws {
        return try await photoLibrary.performChanges {
            guard
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album.underlyingAssetCollection)
            else {
                Logger.log(error: AespaError.album(reason: .unabledToAccess))
                return
            }

            let enumeration = NSArray(object: asset)
            albumChangeRequest.addAssets(enumeration)
            
            Logger.log(message: "File is added to album")
        }
    }
}
