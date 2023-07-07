//
//  PhotoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import SwiftUI
import Foundation
import Photos

public struct PhotoAsset {
    public let asset: PHAsset
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
    var toPhotoFile: PhotoFile {
        PhotoFile(
            creationDate: asset.creationDate ?? Date(timeIntervalSince1970: 0),
            image: uiimage)
    }
    
    var image: Image {
        return Image(uiImage: uiimage)
    }
}

/// `PhotoFile` represents a photo file with its associated metadata.PhotoFile
///
/// This struct holds information about the video file, including the path to the video file (`path`),
/// and an optional thumbnail image (`thumbnail`)
/// generated from the photo.
public struct PhotoFile {
    /// A `Date` value keeps the date it's generated
    public let creationDate: Date

    /// An optional thumbnail generated from the video with `UIImage` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public var image: UIImage
}

extension PhotoFile: Comparable {
    public static func < (lhs: PhotoFile, rhs: PhotoFile) -> Bool {
        lhs.creationDate > rhs.creationDate
    }
}

public extension PhotoFile {
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image {
        return Image(uiImage: image)
    }
}
