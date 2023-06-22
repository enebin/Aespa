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
           
        guard let originalImage = UIImage(data: data) else {
            return nil
        }

        let size = CGSize(width: 250, height: 250)
        let renderer = UIGraphicsImageRenderer(size: size)

        let thumbnail = renderer.image { _ in
            originalImage.draw(in: CGRect(origin: .zero, size: size))
        }

        return thumbnail
    }
}
