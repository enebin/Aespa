//
//  PhotoFile.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import SwiftUI
import Foundation

public struct PhotoFile: Identifiable, Equatable {
    public let id = UUID()

    /// A `Data` value containing image's raw data
    public let data: Data

    /// A `Date` value keeps the date it's generated
    public let generatedDate: Date

    /// An optional thumbnail generated from the video with `UIImage` type.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public var thumbnail: UIImage?
}

extension PhotoFile: Comparable {
    public static func < (lhs: PhotoFile, rhs: PhotoFile) -> Bool {
        lhs.generatedDate > rhs.generatedDate
    }
}
