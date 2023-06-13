//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import UIKit
import AVFoundation

struct VideoFileGenerator {
    static private let cache = URLCache.shared

    static func generate(with path: URL, date: Date = Date()) -> VideoFile {
        return VideoFile(generatedDate: date, path: path)
    }
    
    static func generateThumbnail(for path: URL) -> UIImage? {
        if let image = retreiveImageFromCache(path: path) {
            return image
        }
        
        let asset = AVURLAsset(url: path, options: nil)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            saveImageToCache(path: path, image: thumbnail)
            return thumbnail
        } catch let error {
            Logger.log(error: error)
            return nil
        }
    }
}

private extension VideoFileGenerator {
    static func retreiveImageFromCache(path: URL) -> UIImage? {
        let request = URLRequest(url: path)

        guard
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        else {
            return nil
        }
        
        return image
    }
    
    static func saveImageToCache(path: URL, image: UIImage) {
        let request = URLRequest(url: path)
        
        guard
            let response = HTTPURLResponse(url: path, statusCode: 200, httpVersion: nil, headerFields: nil),
            let data = image.pngData()
        else {
            return
        }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: request)
    }
}
