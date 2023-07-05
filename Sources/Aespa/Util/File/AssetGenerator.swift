//
//  AssetGenerator.swift
//  
//
//  Created by 이영빈 on 2023/07/05.
//

import Photos
import Foundation

struct AssetGenerator {
    static func generateVideoAsset(at path: URL) throws -> PHObjectPlaceholder {
        guard
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
            let placeholder = assetChangeRequest.placeholderForCreatedAsset
        else {
            throw AespaError.file(reason: .unableToChangeAsset)
        }
        
        return placeholder
    }
    
    static func generateImageAsset(at path: URL) throws -> PHObjectPlaceholder {
        guard
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: path),
            let placeholder = assetChangeRequest.placeholderForCreatedAsset
        else {
            throw AespaError.file(reason: .unableToChangeAsset)
        }
        
        return placeholder
    }
}
