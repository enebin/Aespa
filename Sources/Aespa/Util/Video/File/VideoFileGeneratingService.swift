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

struct VideoFileGeneratingService {}

extension VideoFileGeneratingService: Service {
    enum Command {
        case generatingVideoFile(path: URL)
    }
    
    func process(_ input: Command) -> VideoFile {
        switch input {
        case .generatingVideoFile(path: let path):
            return generateVideoFile(of: path)
        }
    }
}

private extension VideoFileGeneratingService {
    func generateVideoFile(of path: URL) -> VideoFile {
        let thumbnail = generateThumbnail(for: path)
        
        return VideoFile(path: path, thumbnail: thumbnail)
    }
    
    func generateThumbnail(for path: URL) -> UIImage? {
        let asset = AVURLAsset(url: path, options: nil)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
        } catch let error {
            LoggingManager.logger.log(error: error)
            return nil
        }
    }
}
