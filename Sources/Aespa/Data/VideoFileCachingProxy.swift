//
//  VideoFileCachingProxy.swift
//  
//
//  Created by 이영빈 on 2023/06/14.
//

import Foundation

class VideoFileCachingProxy {
    private let albumDirectory: URL
    private let cacheEnabled: Bool

    private let fileManager: FileManager

    private var cacheStroage: URLCacheStorage<VideoFile>
    private var lastModificationDate: Date?

    init(
        albumDirectory: URL,
        enableCaching: Bool,
        fileManager: FileManager,
        cacheStorage: URLCacheStorage<VideoFile> = .init()
    ) {
        self.albumDirectory = albumDirectory
        self.cacheStroage = cacheStorage
        
        self.cacheEnabled = enableCaching
        self.fileManager = fileManager

        DispatchQueue.global().async {
            self.update(cacheStorage)
        }
    }

    /// If `count` is `0`, return all existing files
    func fetch(count: Int) -> [VideoFile] {
        guard cacheEnabled else {
            invalidateCache()
            return fetchSortedFiles(count: count)
        }

        // Get directory's last modification date
        guard
            let directoryAttributes = try? fileManager.attributesOfItem(atPath: albumDirectory.path),
            let currentModificationDate = directoryAttributes[.modificationDate] as? Date
        else {
            return []
        }

        // Check if the directory has been modified since last fetch
        if let lastModificationDate, lastModificationDate == currentModificationDate {
            // If it's corrupted, newly fetch files
            return fetchSortedFiles(count: count)
        }

        // Update cache and lastModificationDate
        update(cacheStroage)
        lastModificationDate = currentModificationDate

        return fetchSortedFiles(count: count)
    }

    // Invalidate the cache if needed, for example when a file is added or removed
    func invalidateCache() {
        lastModificationDate = nil
        cacheStroage.empty()
    }
}

private extension VideoFileCachingProxy {
    func update(_ storage: URLCacheStorage<VideoFile>) {
        guard
            let filePaths = try? fileManager.contentsOfDirectory(atPath: albumDirectory.path)
        else {
            Logger.log(message: "Cannot access to saved video file")
            return
        }

        let newPair = filePaths.reduce([URL: VideoFile]()) { previousDictionary, fileName in
            let filePath = albumDirectory.appendingPathComponent(fileName)
            var dictionary = previousDictionary
            
            if let videoFile = storage.get(filePath) {
                dictionary[filePath] = videoFile
            } else if let videoFile = createVideoFile(for: filePath) {
                dictionary[filePath] = videoFile
            }
            
            return dictionary
        }
        
        storage.renew(with: newPair)
    }

    func createVideoFile(for filePath: URL) -> VideoFile? {
        guard
            let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath.path),
            let creationDate = fileAttributes[.creationDate] as? Date
        else {
            Logger.log(message: "Cannot access to saved video file")
            return nil
        }

        return VideoFileGenerator.generate(with: filePath, date: creationDate)
    }

    func fetchSortedFiles(count: Int) -> [VideoFile] {
        let files = cacheStroage.all.sorted()
        return count == 0 ? files : Array(files.prefix(count))
    }
}
