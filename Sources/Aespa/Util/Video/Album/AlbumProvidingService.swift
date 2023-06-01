//
//  VideoAlbumProvider.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

import Photos
import UIKit

struct AlbumProvidingService {
    // Dependencies
    private let photoLibrary: PHPhotoLibrary
    
    init(
        _ photoLibrary: PHPhotoLibrary = .shared()
    ) {
        self.photoLibrary = photoLibrary
    }
}

extension AlbumProvidingService: Service {
    enum Command {
        case get(albumName: String)
    }
    
    func process(_ input: Command) throws -> PHAssetCollection {
        switch input {
        case .get(albumName: let albumName):
            return try getAlbum(name: albumName)
        }
    }
}

private extension AlbumProvidingService {
    func getAlbum(name: String) throws -> PHAssetCollection {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album, subtype: .any, options: fetchOptions
        )
        
        if let album = collection.firstObject {
            return album
        } else {
            try createAlbum(name: name)
            return try getAlbum(name: name)
        }
    }
    
    func createAlbum(name: String) throws {
        try photoLibrary.performChangesAndWait {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }
    }
}
