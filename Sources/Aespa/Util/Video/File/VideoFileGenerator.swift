//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import UIKit
import AVFoundation

/// `VideoFile` represents a video file with its associated metadata.
///
/// This struct holds information about the video file, including a unique identifier (`id`),
/// the path to the video file (`path`), and an optional thumbnail image (`thumbnail`)
/// generated from the video.
public struct VideoFile: Identifiable, Equatable {
    /// A unique identifier for the video file.
    public let id = UUID()
    
    /// The path to the video file.
    public let path: URL
    
    /// An optional thumbnail image generated from the video.
    /// This will be `nil` if the thumbnail could not be generated for some reason.
    public let thumbnail: UIImage?
}

struct VideoFileGenerator {
    static func generate(with path: URL) -> VideoFile {
        let thumbnail = generateThumbnail(for: path)
        
        return VideoFile(path: path, thumbnail: thumbnail)
    }
}

private extension VideoFileGenerator {
    static func generateVideoFile(of path: URL) -> VideoFile {
        let thumbnail = generateThumbnail(for: path)
        
        return VideoFile(path: path, thumbnail: thumbnail)
    }
    
    static func generateThumbnail(for path: URL) -> UIImage? {
        let asset = AVURLAsset(url: path, options: nil)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
        } catch let error {
            Logger.log(error: error)
            return nil
        }
    }
}
