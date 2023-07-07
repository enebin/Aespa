//
//  AespaProcessing.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import Foundation
import AVFoundation

protocol AespaCapturePhotoOutputProcessing {
    func process<T: AespaPhotoOutputRepresentable>(_ output: T) throws
}

protocol AespaMovieFileOutputProcessing {
    func process<T: AespaFileOutputRepresentable>(_ output: T) throws
}

protocol AespaAssetProcessing {
    func process<Library, Collection>(
        _ library: Library,
        _ collection: Collection
    ) async throws
    where Library: AespaAssetLibraryRepresentable,
          Collection: AespaAssetCollectionRepresentable
}

protocol AespaFileProcessing {
    func process(_ fileManager: FileManager) throws
}
