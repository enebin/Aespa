//
//  FileWritingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/07/06.
//

import Foundation

struct FileWritingProcessor: AespaFileProcessing {
    let data: Data
    let path: URL
    
    func process(_ fileManager: FileManager) throws {
        // Check if the directory exists, if not, returns.
        guard !fileManager.fileExists(atPath: path.deletingLastPathComponent().absoluteString) else {
            throw AespaError.file(reason: .alreadyExist)
        }
        
        try data.write(to: path)
    }
}
