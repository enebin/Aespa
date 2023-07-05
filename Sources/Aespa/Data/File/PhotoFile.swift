//
//  PhotoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import SwiftUI
import Foundation

/// `PhotoFile` represents a photo file with its associated metadata.
///
/// This struct holds information about the video file, including the path to the video file (`path`),
/// and an optional thumbnail image (`thumbnail`)
/// generated from the photo.
public struct PhotoFile {    
    /// A `Date` value keeps the date it's generated
    public let generatedDate: Date
    
    /// The path to the photo file data. It's saved in the form of `Data.
    /// If you want to load it directly you should encode it to any image type.
    public let path: URL

    /// An optional thumbnail generated from the video with `UIImage` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public var thumbnail: UIImage?
}

extension PhotoFile: Identifiable {
    public var id: URL {
        self.path
    }
}

extension PhotoFile: Equatable {
    public static func == (lhs: PhotoFile, rhs: PhotoFile) -> Bool {
        lhs.path == rhs.path
    }
}

extension PhotoFile: Comparable {
    public static func < (lhs: PhotoFile, rhs: PhotoFile) -> Bool {
        lhs.generatedDate > rhs.generatedDate
    }
}

public extension PhotoFile {
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image? {
        if let thumbnail {
            return Image(uiImage: thumbnail)
        }
        
        return nil
    }
}
