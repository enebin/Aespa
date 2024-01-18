//
//  File.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import Foundation

struct PhotoFileGenerator {
    static func generate(data: Data, date: Date) -> PhotoFile {
        return PhotoFile(
            creationDate: date,
            image: PhotoFileGenerator.generateImage(from: data) ?? UIImage())
    }
    
    static func generateImage(from data: Data) -> UIImage? {
        guard let compressedImageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        return UIImage(data: compressedImageData)
    }
}
