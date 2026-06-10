//
//  AespaAssetLoading.swift
//  
//
//  Created by 이영빈 on 2023/07/02.
//

import Foundation

nonisolated protocol AespaAssetLoading: Sendable {
    associatedtype ReturnType
    
    func loadAssets<Library, Collection>(_ library: Library, _ collection: Collection) throws -> ReturnType
    where Library: AespaAssetLibraryRepresentable,
          Collection: AespaAssetCollectionRepresentable
}
