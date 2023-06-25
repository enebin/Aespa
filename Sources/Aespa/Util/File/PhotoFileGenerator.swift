//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import Foundation

struct PhotoFileGenerator {
    static func generate(with path: URL, date: Date) -> PhotoFile {
        return PhotoFile(
            generatedDate: date,
            path: path,
            thumbnail: PhotoFileGenerator.generateThumbnail(for: path))
    }
    
    static func generateThumbnail(for path: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: path) else {
            return nil
        }
           
        guard let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        return UIImage(data: compressedImageData)
    }
}
