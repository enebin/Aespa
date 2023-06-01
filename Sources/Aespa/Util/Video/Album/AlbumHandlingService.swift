//
//  VideoAlbumHandlingService.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation
import Photos


struct AlbumHandlingService {
    // Dependencies
    private let albumImporter: AlbumProvidingService
    private let photoLibrary: PHPhotoLibrary
    
    private let albumName: String
    
    init(
        albumName: String,
        _ albumProvider: AlbumProvidingService = .init(),
        _ photoLibrary: PHPhotoLibrary = .shared()
    ) {
        self.albumName = albumName
        self.albumImporter = albumProvider
        self.photoLibrary = photoLibrary
    }
}

extension AlbumHandlingService: Service {
    enum Command {
        case addition(path: URL)
        case removal(path: URL)
    }
    
    func process(_ command: Command) async throws {
        switch command {
        case .addition(path: let path):
            try await add(video: path)
        case .removal(path: let path):
            try await remove(video: path)
        }
    }
}

private extension AlbumHandlingService {
    /// Recommended to be executed on background queue
    func add(video path: URL) async throws {
        guard
            case .authorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        else {
            let error = AespaError.album(reason: .unabledToAccess)
            LoggingManager.logger.log(error: error)
            throw error
        }
        
        let album = try albumImporter.process(.get(albumName: albumName))
        try await add(video: path, to: album)
    }

    /// Add the video to the app's album roll
    func add(video path: URL, to album: PHAssetCollection) async throws -> Void {
        return try await photoLibrary.performChanges {
            if
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
                let placeholder = assetChangeRequest.placeholderForCreatedAsset
            {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration = NSArray(object: placeholder)
                
                albumChangeRequest?.addAssets(enumeration)
            }
        }
    }
    
    // TODO: add later
    func remove(video path: URL) async throws {
//        guard
    }
}
