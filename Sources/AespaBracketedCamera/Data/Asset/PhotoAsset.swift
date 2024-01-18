//
//  PhotoAsset.swift
//  
//
//  Created by 이영빈 on 2023/07/07.
//

import UIKit
import Photos
import SwiftUI
import Foundation

/// Struct to represent a photo asset saved in the album.
public struct PhotoAsset {
    /// The associated `PHAsset` object from the Photos framework.
    public let asset: PHAsset
    
    /// The `UIImage` representation of the asset.
    public let uiimage: UIImage
}

extension PhotoAsset: Identifiable {
    public var id: String {
        asset.localIdentifier
    }
}

extension PhotoAsset: Equatable {}

extension PhotoAsset: Comparable {
    public static func < (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        creationDateOfAsset(lhs.asset) > creationDateOfAsset(rhs.asset)
    }
    
    private static func creationDateOfAsset(_ asset: PHAsset) -> Date {
        return asset.creationDate ?? Date(timeIntervalSince1970: 0)
    }
}

public extension PhotoAsset {
    /// Transforms a `PhotoAsset` to a `PhotoFile`.
    var toPhotoFile: PhotoFile {
        PhotoFile(
            creationDate: asset.creationDate ?? Date(timeIntervalSince1970: 0),
            image: uiimage)
    }
    
    /// Creates a SwiftUI `Image` from the `UIImage` of the `PhotoAsset`.
    var image: Image {
        return Image(uiImage: uiimage)
    }
}
