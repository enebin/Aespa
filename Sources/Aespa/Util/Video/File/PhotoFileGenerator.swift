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
            data: data, 
            generatedDate: date,
            thumbnail: UIImage(data: data))
    }
}
