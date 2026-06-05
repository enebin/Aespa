//
//  AespaProcessing.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import Foundation
import AVFoundation

nonisolated protocol AespaCapturePhotoOutputProcessing: Sendable {
    func process<T: AespaPhotoOutputRepresentable>(_ output: T) throws
}

nonisolated protocol AespaMovieFileOutputProcessing: Sendable {
    func process<T: AespaFileOutputRepresentable>(_ output: T) throws
}

nonisolated protocol AespaAssetProcessing: Sendable {
    func process<Library, Collection>(
        _ library: Library,
        _ collection: Collection
    ) async throws
    where Library: AespaAssetLibraryRepresentable,
          Collection: AespaAssetCollectionRepresentable
}

nonisolated protocol AespaFileProcessing: Sendable {
    func process(_ fileManager: FileManager) throws
}
