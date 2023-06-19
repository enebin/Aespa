//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import UIKit
import AVFoundation

struct VideoFileGenerator {
    static func generate(with path: URL, date: Date) -> VideoFile {
        return VideoFile(
            generatedDate: date,
            path: path,
            thumbnail: VideoFileGenerator.generateThumbnail(for: path))
    }

    static func generateThumbnail(for path: URL) -> UIImage? {
        let asset = AVURLAsset(url: path, options: nil)

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = .init(width: 250, height: 250)

        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1),
                                                         actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail
        } catch let error {
            Logger.log(error: error)
            return nil
        }
    }
}
