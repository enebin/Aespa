//
//  VideoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/13.
//

import UIKit
import Photos
import SwiftUI
import AVFoundation


public struct VideoAsset {
    private let phAsset: PHAsset
    public let asset: AVAsset
    public let thumbnail: UIImage
    
    public init(phAsset: PHAsset, asset: AVAsset, thumbnail: UIImage) {
        self.phAsset = phAsset
        self.asset = asset
        self.thumbnail = thumbnail
    }
}

extension VideoAsset: Identifiable {
    public var id: String {
        phAsset.localIdentifier
    }
}

extension VideoAsset: Equatable {}

extension VideoAsset: Comparable {
    public static func < (lhs: VideoAsset, rhs: VideoAsset) -> Bool {
        creationDateOfAsset(lhs.phAsset) > creationDateOfAsset(rhs.phAsset)
    }
    
    private static func creationDateOfAsset(_ asset: PHAsset) -> Date {
        return asset.creationDate ?? Date(timeIntervalSince1970: 0)
    }
}

public extension VideoAsset {
    var toVideoFile: VideoFile {
        VideoFile(
            creationDate: phAsset.creationDate ?? Date(timeIntervalSince1970: 0),
            path: nil,
            thumbnail: thumbnail)
    }
    
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image {
        Image(uiImage: thumbnail)
    }
}

/// `VideoFile` represents a video file with its associated metadata.
///
/// This struct holds information about the video file, including the path to the video file (`path`),
/// and an optional thumbnail image (`thumbnail`)
/// generated from the video.
public struct VideoFile {
    /// A `Date` value keeps the date it's generated
    public let creationDate: Date

    /// The path to the video file.
    public let path: URL?

    /// An optional thumbnail generated from the video with `UIImage` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public var thumbnail: UIImage
}

extension VideoFile: Comparable {
    public static func < (lhs: VideoFile, rhs: VideoFile) -> Bool {
        lhs.creationDate > rhs.creationDate
    }
}

public extension VideoFile {
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image {
        Image(uiImage: thumbnail)
    }
}
