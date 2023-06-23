//
//  MockImage.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/23.
//

import UIKit
import Foundation

class MockImage {
    let dirPath: URL
    let path: URL
    
    init() {
        let fileName = "image"
        
        dirPath = FileManager.default.temporaryDirectory
        path = dirPath.appendingPathComponent(fileName)
        
        let imageData = UIImage(systemName: "person")!.pngData()!
        try! imageData.write(to: path)
    }
}

