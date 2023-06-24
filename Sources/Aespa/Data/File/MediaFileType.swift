//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/23.
//

import UIKit
import SwiftUI
import Foundation

public protocol MediaFileType: Identifiable, Equatable, Comparable {
    /// A `Date` value keeps the date it's generated
    var generatedDate: Date { get }
    
    /// The path to the file data.
    var path: URL { get }

    /// An optional thumbnail generated from the video with `UIImage` type.
    var thumbnail: UIImage? { get }
}

extension MediaFileType {
    public var id: URL {
        self.path
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.path == rhs.path
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.generatedDate > rhs.generatedDate
    }
}

/// UI related extension methods
public extension MediaFileType {
    /// An optional thumbnail generated from the video with SwiftUI `Image` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    var thumbnailImage: Image? {
        if let thumbnail {
            return Image(uiImage: thumbnail)
        }

        return nil
    }
}
