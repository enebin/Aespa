//
//  VideoAlbumProvider.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

import Photos
import UIKit

struct AlbumImporter {
    static func getAlbum(name: String, in photoLibrary: PHPhotoLibrary) throws -> PHAssetCollection {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album, subtype: .any, options: fetchOptions
        )
        
        if let album = collection.firstObject {
            return album
        } else {
            try createAlbum(name: name, in: photoLibrary)
            return try getAlbum(name: name, in: photoLibrary)
        }
    }
    
    static private func createAlbum(name: String, in photoLibrary: PHPhotoLibrary) throws {
        try photoLibrary.performChangesAndWait {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }
    }
}
