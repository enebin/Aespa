//
//  PhotoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import SwiftUI
import Foundation

/// `PhotoFile` struct models a photo file along with its related metadata.
///
/// The struct represents different details about a photo file, such as its creation date and the image itself.
/// To get more meta data from the image, you should refer to `PhotoAsset`
public struct PhotoFile {
    /// A `Date` value indicating the moment the photo was taken.
    public let creationDate: Date

    /// The captured image of type `UIImage`.
    public var image: UIImage
}

extension PhotoFile: Comparable {
    public static func < (lhs: PhotoFile, rhs: PhotoFile) -> Bool {
        lhs.creationDate > rhs.creationDate
    }
}

public extension PhotoFile {
    /// The captured image presented as a SwiftUI `Image`.
    var thumbnailImage: Image {
        return Image(uiImage: image)
    }
}
