//
//  AssetLoader.swift
//  
//
//  Created by Young Bin on 2023/07/03.
//

import Photos
import Foundation

struct AssetLoader: AespaAssetLoading {
    let limit: Int
    let assetType: PHAssetMediaType
    
    func laodFetchResult<
        Library: AespaAssetLibraryRepresentable, Collection: AespaAssetCollectionRepresentable
    >(
        _ photoLibrary: Library,
        _ assetCollection: Collection
    ) throws -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = limit
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", assetType.rawValue)
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        
        guard let assetCollection = assetCollection as? PHAssetCollection else {
            fatalError("Asset collection doesn't conform to PHAssetCollection")
        }
        
        return PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
    
    func loadAssets<
        Library: AespaAssetLibraryRepresentable, Collection: AespaAssetCollectionRepresentable
    >(
        _ photoLibrary: Library,
        _ assetCollection: Collection
    ) throws -> [PHAsset] {
        var assets = [PHAsset]()
        let assetsFetchResult = try laodFetchResult(photoLibrary, assetCollection)
        assetsFetchResult.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        
        return assets
    }
}
