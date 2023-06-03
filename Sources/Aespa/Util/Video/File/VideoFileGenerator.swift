//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import UIKit
import AVFoundation

public struct VideoFile: Identifiable, Equatable {
    public let id = UUID()
    public let path: URL
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
