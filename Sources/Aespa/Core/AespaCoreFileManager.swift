//
//  AespaCoreFileManager.swift
//
//
//  Created by 이영빈 on 2023/06/13.
//

import Foundation

class AespaCoreFileManager {
    private var videoFileProxyDictionary: [String: VideoFileCachingProxy]
    private let enableCaching: Bool

    let systemFileManager: FileManager

    init(
        enableCaching: Bool,
        fileManager: FileManager = .default
    ) {
        videoFileProxyDictionary = [:]
        self.enableCaching = enableCaching
        self.systemFileManager = fileManager
    }

    /// If `count` is `0`, return all existing files
    func fetch(albumName: String, count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }
        
        guard let albumDirectory = try? VideoFilePathProvider.requestDirectoryPath(from: systemFileManager,
                                                                                   name: albumName)
        else {
            Logger.log(message: "Cannot fetch album directory so `fetch` will return empty array.")
            return []
        }

        guard let proxy = videoFileProxyDictionary[albumName] else {
            videoFileProxyDictionary[albumName] = VideoFileCachingProxy(
                albumDirectory: albumDirectory, 
                enableCaching: enableCaching,
                fileManager: systemFileManager)

            return fetch(albumName: albumName, count: count)
        }

        let files = proxy.fetch(count: count)
        Logger.log(message: "\(files.count) Video files fetched")
        return files
    }
}
