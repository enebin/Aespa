//
//  AespaCoreFileManager.swift
//
//
//  Created by 이영빈 on 2023/06/13.
//

import Photos
import Foundation

class AespaCoreFileManager {
    private var videoFileProxyDictionary: [String: FileCachingProxy<VideoFile>]
    private var photoFileProxyDictionary: [String: FileCachingProxy<PhotoFile>]
    private let enableCaching: Bool

    let systemFileManager: FileManager

    init(
        enableCaching: Bool,
        fileManager: FileManager = .default
    ) {
        self.videoFileProxyDictionary = [:]
        self.photoFileProxyDictionary = [:]
        
        self.enableCaching = enableCaching
        self.systemFileManager = fileManager
    }
    
    func write(data: Data, to path: URL) throws {
        // Check if the directory exists, if not, create it.
        if !systemFileManager.fileExists(atPath: path.deletingLastPathComponent().absoluteString) {
            try systemFileManager.createDirectory(at: path.deletingLastPathComponent(),
                                                  withIntermediateDirectories: true)
        }

        // Write data to the path
        try data.write(to: path)
    }
    
    func fetchPhoto(albumName: String, count: Int) -> [PhotoFile] {
        guard count >= 0 else { return [] }
        
        // TODO: Fixit
        guard
            let albumDirectory = try? VideoFilePathProvider.requestDirectoryPath(from: systemFileManager,
                                                                                 name: albumName)
        else {
            Logger.log(message: "Cannot fetch album directory so `fetch` will return empty array.")
            return []
        }

        guard let proxy = photoFileProxyDictionary[albumName] else {
            photoFileProxyDictionary[albumName] = FileCachingProxy(
                fileDirectory: albumDirectory,
                enableCaching: enableCaching,
                fileManager: systemFileManager,
                fileFactory: photoFileFactory)
            
            return fetchPhoto(albumName: albumName, count: count)
        }

        let files = proxy.fetch(count: count)
        Logger.log(message: "\(files.count) Photo files fetched")
        return files
    }
    
    /// If `count` is `0`, return all existing files
    func fetchVideo(albumName: String, count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        guard
            let albumDirectory = try? VideoFilePathProvider.requestDirectoryPath(from: systemFileManager,
                                                                                 name: albumName)
        else {
            Logger.log(message: "Cannot fetch album directory so `fetch` will return empty array.")
            return []
        }

        guard let proxy = videoFileProxyDictionary[albumName] else {
            videoFileProxyDictionary[albumName] = FileCachingProxy(
                fileDirectory: albumDirectory,
                enableCaching: enableCaching,
                fileManager: systemFileManager,
                fileFactory: videoFileFactory)

            return fetchVideo(albumName: albumName, count: count)
        }

        let files = proxy.fetch(count: count)
        Logger.log(message: "\(files.count) Video files fetched")
        return files
    }
}

private extension AespaCoreFileManager {
    func videoFileFactory(_ fileManager: FileManager, _ filePath: URL) -> VideoFile? {
        guard
            let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath.path),
            let creationDate = fileAttributes[.creationDate] as? Date
        else {
            Logger.log(message: "Cannot access to saved video file")
            return nil
        }

        return VideoFileGenerator.generate(with: filePath, date: creationDate)
    }
    
    func photoFileFactory(_ fileManager: FileManager, _ filePath: URL) -> PhotoFile? {
        guard
            let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath.path),
            let creationDate = fileAttributes[.creationDate] as? Date
        else {
            Logger.log(message: "Cannot access to saved photo file")
            return nil
        }

        return PhotoFileGenerator.generate(with: filePath, date: creationDate)
    }
}
