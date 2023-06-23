//
//  VideoFilePathProvidingService.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import UIKit

struct VideoFilePathProvider {
    static func requestFilePath(
        from fileManager: FileManager,
        directoryName: String,
        fileName: String,
        extension: String
    ) throws -> URL {
        let directoryPath = try requestDirectoryPath(from: fileManager, name: directoryName)
        let filePath = directoryPath
            .appendingPathComponent(fileName)
            .appendingPathExtension(`extension`)

        return filePath
    }

    static func requestDirectoryPath(from fileManager: FileManager, name: String) throws -> URL {
        guard
            let albumPath = fileManager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first
        else {
            throw AespaError.album(reason: .unabledToAccess)
        }

        let directoryPathURL = albumPath.appendingPathComponent(name, isDirectory: true)

        // Set directory if doesn't exist
        if fileManager.fileExists(atPath: directoryPathURL.path) == false {
            try fileManager.createDirectory(
                atPath: directoryPathURL.path,
                withIntermediateDirectories: true,
                attributes: nil)
        }

        return directoryPathURL
    }
}

struct FilePathProvider {
    static func requestFilePath(
        from fileManager: FileManager,
        directoryName: String,
        subDirectoryName: String,
        fileName: String,
        extension: String? = nil
    ) throws -> URL {
        let directoryPath = try requestDirectoryPath(
            from: fileManager,
            directoryName: directoryName,
            subDirectoryName: subDirectoryName)
        
        let filePath = directoryPath
            .appendingPathComponent(fileName)
            .appendingPathExtension(`extension` ?? "")

        return filePath
    }
    
    static func requestDirectoryPath(
        from fileManager: FileManager,
        directoryName: String,
        subDirectoryName: String? = nil
    ) throws -> URL {
        guard
            let albumPath = fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask)
                .first
        else {
            throw AespaError.album(reason: .unabledToAccess)
        }

        var directoryPathURL = albumPath.appendingPathComponent(directoryName, isDirectory: true)
        
        if let subDirectoryName = subDirectoryName {
            directoryPathURL = directoryPathURL.appendingPathComponent(subDirectoryName, isDirectory: true)
        }

        // Create directory if doesn't exist
        if !fileManager.fileExists(atPath: directoryPathURL.path) {
            try fileManager.createDirectory(
                at: directoryPathURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }

        return directoryPathURL
    }
}