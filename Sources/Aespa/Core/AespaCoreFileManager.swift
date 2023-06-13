//
//  AespaCoreFileManager.swift
//  
//
//  Created by 이영빈 on 2023/06/13.
//

import Foundation

class AespaCoreFileManager {
    let systemFileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.systemFileManager = fileManager
    }
    
    /// If `count` is `0`, return all existing files
    func fetch(albumName: String, count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        do {
            let directoryPath = try VideoFilePathProvider.requestDirectoryPath(from: systemFileManager,
                                                                               name: albumName)
            
            let filePaths = try systemFileManager.contentsOfDirectory(atPath: directoryPath.path)
            let filePathPrefix = count == 0 ? filePaths : Array(filePaths.prefix(count))
            
            return filePathPrefix
                .map { name -> URL in
                    return directoryPath.appendingPathComponent(name)
                }
                .map { filePath -> VideoFile in
                    return VideoFileGenerator.generate(with: filePath)
                }
                .sorted() // Sorted by date(recent date first)

        } catch let error {
            Logger.log(error: error)
            return []
        }
    }
}
