//
//  MockVideo.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/18.
//

import Foundation

class MockVideo {
    let dirPath: URL
    let path: URL?
    init() {
        let fileName = "video"
        
        dirPath = Bundle(for: type(of: self)).bundleURL
        
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "mp4") {
            self.path = URL(fileURLWithPath: path)
        } else {   
            self.path = nil
        }
    }
}
