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
    static func getAlbum<Library: AespaAssetLibraryRepresentable, Collection: AespaAssetCollectionRepresentable>(
        name: String,
        in photoLibrary: Library,
        retry: Bool = true,
        _ fetchOptions: PHFetchOptions = .init()
    ) throws -> Collection {
        let album: Collection? = photoLibrary.fetchAlbum(title: name, fetchOptions: fetchOptions)

        if let album {
            return album
        } else if retry {
            try createAlbum(name: name, in: photoLibrary)
            return try getAlbum(name: name, in: photoLibrary, retry: false, fetchOptions)
        } else {
            throw AespaError.album(reason: .unabledToAccess)
        }
    }
    
    static private func createAlbum<Library: AespaAssetLibraryRepresentable>(
        name: String,
        in photoLibrary: Library
    ) throws {
        try photoLibrary.performChangesAndWait {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }
    }
}
