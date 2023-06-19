//
//  VideoFileCachingProxy.swift
//  
//
//  Created by 이영빈 on 2023/06/14.
//

import Foundation

class VideoFileCachingProxy {
    private let albumName: String
    private let cacheEnabled: Bool

    private let fileManager: FileManager

    private var cache: [URL: VideoFile] = [:]
    private var lastModificationDate: Date?

    init(albumName: String, enableCaching: Bool, fileManager: FileManager) {
        self.albumName = albumName
        self.cacheEnabled = enableCaching
        self.fileManager = fileManager

        DispatchQueue.global().async {
            self.updateCache()
        }
    }

    /// If `count` is `0`, return all existing files
    func fetch(count: Int) -> [VideoFile] {
        guard
            let albumDirectory = try? VideoFilePathProvider.requestDirectoryPath(from: fileManager,
                                                                                 name: albumName)
        else {
            return []
        }

        guard cacheEnabled else {
            invalidateCache()
            return fetchFile(from: albumDirectory, count: count).sorted()
        }

        guard
            let directoryAttributes = try? fileManager.attributesOfItem(atPath: albumDirectory.path),
            let currentModificationDate = directoryAttributes[.modificationDate] as? Date
        else {
            return []
        }

        // Check if the directory has been modified since last fetch
        if let lastModificationDate = self.lastModificationDate,
           lastModificationDate == currentModificationDate {
            return fetchSortedFiles(count: count)
        }

        // Update cache and lastModificationDate
        updateCache()
        self.lastModificationDate = currentModificationDate

        return fetchSortedFiles(count: count)
    }

    // Invalidate the cache if needed, for example when a file is added or removed
    func invalidateCache() {
        cache.removeAll()
        lastModificationDate = nil
    }
}

private extension VideoFileCachingProxy {
    func updateCache() {
        guard
            let albumDirectory = try? VideoFilePathProvider.requestDirectoryPath(from: fileManager,
                                                                                 name: albumName),
            let filePaths = try? fileManager.contentsOfDirectory(atPath: albumDirectory.path)
        else {
            Logger.log(message: "Cannot access to saved video file")
            return
        }

        var newCache: [URL: VideoFile] = [:]
        filePaths.forEach { fileName in
            let filePath = albumDirectory.appendingPathComponent(fileName)
            if let cachedFile = cache[filePath] {
                newCache[filePath] = cachedFile
            } else if let videoFile = createVideoFile(for: filePath) {
                newCache[filePath] = videoFile
            }
        }
        cache = newCache
    }

    func fetchFile(from albumDirectory: URL, count: Int) -> [VideoFile] {
        guard count >= 0 else { return [] }

        let files = Array(cache.values)
        let sortedFiles = files.sorted()
        let prefixFiles = (count == 0) ? sortedFiles : Array(sortedFiles.prefix(count))
        return prefixFiles
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
        let files = cache.values.sorted()
        return count == 0 ? files : Array(files.prefix(count))
    }
}
