//
//  VideoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/13.
//

import UIKit
import SwiftUI
import AVFoundation

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

/// UI related extension methods
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
