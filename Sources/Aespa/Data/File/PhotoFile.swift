//
//  PhotoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import SwiftUI
import Foundation

public struct PhotoFile {
    /// A `Date` value keeps the date it's generated
    public let generatedDate: Date
    
    /// The path to the photo file data.
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
