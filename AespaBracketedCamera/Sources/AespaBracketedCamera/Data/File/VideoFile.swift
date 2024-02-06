//
//  VideoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/13.
//

import UIKit
import SwiftUI

/// `VideoFile` represents a video file along with its related metadata.
///
/// This struct encapsulates various information about a video file, such as the file's path (`path`)
/// and a thumbnail image (`thumbnail`) derived from the video content.
///
/// - Warning: The path is temporary and will be removed once the application terminates.
public struct VideoFile {
    /// A `Date` value representing when the video file was created.
    public let creationDate: Date

    /// The temporary path of the recorded video file.
    ///
    /// - Warning: This path is temporary and will be removed when the application terminates.
    public let path: URL?

    /// A thumbnail image, of type `UIImage`, generated from the video.
    public var thumbnail: UIImage
}

extension VideoFile: Comparable {
    public static func < (lhs: VideoFile, rhs: VideoFile) -> Bool {
        lhs.creationDate > rhs.creationDate
    }
}

public extension VideoFile {
    /// A thumbnail image, of type SwiftUI `Image`, generated from the video.
    var thumbnailImage: Image {
        Image(uiImage: thumbnail)
    }
}
