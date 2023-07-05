//
//  AssetAdditionProcessor.swift
//  
//
//  Created by 이영빈 on 2023/07/05.
//

import Photos
import Foundation


struct AssetAdditionProcessor: AespaAssetProcessing {
    let filePath: URL
    let mediaType: MediaType

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

        try await add(filePath, to: assetCollection, photoLibrary)
    }

    /// Add the file to the app's album roll
    func add<
        T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
    >(
        _ path: URL,
        to album: U,
        _ photoLibrary: T
    ) async throws {
        let placeholder: PHObjectPlaceholder
        switch mediaType {
        case .photo:
            placeholder = try AssetGenerator.generateImageAsset(at: path)
        case .video:
            placeholder = try AssetGenerator.generateVideoAsset(at: path)
        }

        return try await photoLibrary.performChanges {
            guard
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album.underlyingAssetCollection)
            else {
                Logger.log(error: AespaError.album(reason: .unabledToAccess))
                return
            }

            let enumeration = NSArray(object: placeholder)
            albumChangeRequest.addAssets(enumeration)
            
            Logger.log(message: "\(mediaType.rawValue) file is added to album")
        }
    }
}
