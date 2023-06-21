//
//  VideoFileCachingProxy.swift
//  
//
//  Created by 이영빈 on 2023/06/14.
//

import Foundation

class VideoFileCachingProxy<CacheStorage: URLCaching<VideoFile>> {
    private let albumDirectory: URL
    private let cacheEnabled: Bool

    private let fileManager: FileManager

    private var cacheStroage: CacheStorage
    private(set) var lastModificationDate: Date?

    init(
        albumDirectory: URL,
        enableCaching: Bool,
        fileManager: FileManager,
        cacheStorage: CacheStorage = URLCacheStorage<VideoFile>()
    ) {
        self.albumDirectory = albumDirectory
        self.cacheStroage = cacheStorage
        
        self.cacheEnabled = enableCaching
        self.fileManager = fileManager
    }

    /// If `count` is `0`, return all existing files
    func fetch(count: Int = 0) -> [VideoFile] {
        guard cacheEnabled else {
            return fetchSortedFiles(count: count, usingCache: cacheEnabled)
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
            return fetchSortedFiles(count: count, usingCache: cacheEnabled)
        }

        // Update cache and lastModificationDate
        update(cacheStroage)
        lastModificationDate = currentModificationDate

        return fetchSortedFiles(count: count, usingCache: cacheEnabled)
    }

    // Invalidate the cache if needed, for example when a file is added or removed
    func invalidate() {
        lastModificationDate = nil
        cacheStroage.empty()
    }
    
    func renew() {
        update(cacheStroage)
    }
}

private extension VideoFileCachingProxy {
    func update(_ storage: CacheStorage) {
        guard
            let filePaths = try? fileManager.contentsOfDirectory(atPath: albumDirectory.path)
        else {
            Logger.log(message: "Cannot access to saved video file")
            return
        }

        filePaths.forEach { fileName in
            let filePath = albumDirectory.appendingPathComponent(fileName)
            
            guard storage.get(filePath) == nil else {
                return
            }
            
            guard let videoFile = createVideoFile(for: filePath) else {
                return
            }
            
            storage.store(videoFile, at: filePath)
        }
    }
    
    func fetchSortedFiles(count: Int, usingCache: Bool) -> [VideoFile] {
        let files: [VideoFile]
        if usingCache {
            files = cacheStroage.all.sorted()
        } else {
            guard let filePaths = try? fileManager.contentsOfDirectory(atPath: albumDirectory.path) else {
                Logger.log(message: "Cannot access to saved video file")
                return []
            }
            
            files = filePaths
                .map { fileName in
                    let filePath = albumDirectory.appendingPathComponent(fileName)
                    return createVideoFile(for: filePath)
                }
                .compactMap({$0})
        }
        
        return count == 0 ? files : Array(files.prefix(count))
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
}
