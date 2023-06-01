//
//  VideoFilePathProvidingService.swift
//  
//
//  Created by Young Bin on 2023/05/25.
//

import UIKit

class VideoFilePathProvidingService {
    // Dependencies
    private let option: AespaOption.Asset
    private let fileManager: FileManager
    
    private var directoryPathURL: URL?
    
    convenience init(option: AespaOption.Asset) {
        self.init(option: option, fileManager: .default)
    }

    init(
        option: AespaOption.Asset,
        fileManager: FileManager
    ) {
        self.option = option
        self.fileManager = fileManager
    }
}

extension VideoFilePathProvidingService: Service {
    enum Command {
        case getRootDirectoryPath
        case generatingNewFilePath
    }
    
    func process(_ input: Command) throws -> URL {
        switch input {
        case .getRootDirectoryPath:
            return try requestDirectoryURL()
        case .generatingNewFilePath:
            return try requestFileURL()
        }
    }
}

private extension VideoFilePathProvidingService {
    func requestDirectoryURL() throws -> URL {
        if let directoryPathURL {
            return directoryPathURL
        } else {
            directoryPathURL = try configureAlbumDirectory()
            return try requestDirectoryURL()
        }
    }

    /// Request an URL for new file.
    ///
    /// If you haven't created a directory before,
    /// create one and return the address.
    func requestFileURL() throws -> URL {
        if let directoryPathURL {
            let fileName = option.fileNameHandler()
            let filePath = directoryPathURL
                .appendingPathComponent(fileName)
                .appendingPathExtension("mp4")

            return filePath
        } else {
            directoryPathURL = try configureAlbumDirectory()
            return try requestFileURL()
        }
    }
    
    func configureAlbumDirectory() throws -> URL {
        if let directoryPathURL { return directoryPathURL }
        
        // set paths
        guard
            let albumPath = fileManager.urls(for: .documentDirectory,
                                             in: .userDomainMask).first
        else {
            throw AespaError.album(reason: .unabledToAccess)
        }
        
        let directoryPathURL = albumPath.appendingPathComponent(option.albumName, isDirectory: true)
        if fileManager.fileExists(atPath: directoryPathURL.path) == false {
            // Set directory if doesn't exist
            try FileManager.default.createDirectory(
                atPath: directoryPathURL.path,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        
        return directoryPathURL
    }
}
