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
    func process<T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable>(
        _ photoLibrary: T, _ assetCollection: U
    ) async throws
    where T: AespaAssetLibraryRepresentable, U: AespaAssetCollectionRepresentable
}
