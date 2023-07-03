//
//  VideoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/13.
//

import UIKit
import SwiftUI
import AVFoundation


public struct VideoAssetFile {
    public let id: UUID = UUID()
    public let asset: AVAsset
    public let thumbnail: UIImage?
}

extension VideoAssetFile: Identifiable {}

extension VideoAssetFile: Equatable {}

extension VideoAssetFile: Comparable {
    public static func < (lhs: VideoAssetFile, rhs: VideoAssetFile) -> Bool {
        creationDateOfAsset(lhs.asset) > creationDateOfAsset(rhs.asset)
    }
    
    private static func creationDateOfAsset(_ asset: AVAsset) -> Date {
        if
            let creationDateMetadataItem = asset.creationDate,
            let creationDateString = creationDateMetadataItem.stringValue,
            let creationDate = ISO8601DateFormatter().date(from: creationDateString)
        {
            return creationDate
        } else {
            return Date(timeIntervalSince1970: 0)
        }
    }
}

/// `VideoFile` represents a video file with its associated metadata.
///
/// This struct holds information about the video file, including the path to the video file (`path`),
/// and an optional thumbnail image (`thumbnail`)
/// generated from the video.
public struct VideoFile {
    /// A `Date` value keeps the date it's generated
    public let generatedDate: Date

    /// The path to the video file.
    public let path: URL

    /// An optional thumbnail generated from the video with `UIImage` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public var thumbnail: UIImage?
}

extension VideoFile: Identifiable {
    public var id: URL {
        self.path
    }
}

extension VideoFile: Equatable {
    public static func == (lhs: VideoFile, rhs: VideoFile) -> Bool {
        lhs.path == rhs.path
    }
}

extension VideoFile: Comparable {
    public static func < (lhs: VideoFile, rhs: VideoFile) -> Bool {
        lhs.generatedDate > rhs.generatedDate
    }
}

public extension VideoFile {
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image? {
        if let thumbnail {
            return Image(uiImage: thumbnail)
        }
        
        return nil
    }
}
