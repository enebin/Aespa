//
//  ileCachingProxy.swift
//
//
//  Created by 이영빈 on 2023/06/14.
//

import Foundation

class FileCachingProxy<File: Comparable> {
    private let fileDirectory: URL
    private let cacheEnabled: Bool

    private let fileManager: FileManager

    private let fileFactory: (FileManager, URL) -> File?
    
    private var cacheStorage: URLCacheStorage<File>
    private(set) var lastModificationDate: Date?

    init(
        fileDirectory: URL,
        enableCaching: Bool,
        fileManager: FileManager,
        cacheStorage: URLCacheStorage<File> = URLCacheStorage<File>(),
        fileFactory: @escaping (FileManager, URL) -> File?
    ) {
        self.fileDirectory = fileDirectory
        self.cacheEnabled = enableCaching
        self.fileManager = fileManager
        self.cacheStorage = cacheStorage
        self.fileFactory = fileFactory
    }

    /// If `count` is `0`, return all existing files
    func fetch(count: Int = 0) -> [File] {
        guard cacheEnabled else {
            return fetchSortedFiles(count: count, usingCache: cacheEnabled)
        }

        // Get directory's last modification date
        guard
            let directoryAttributes = try? fileManager.attributesOfItem(atPath: fileDirectory.path),
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
        update(cacheStorage)
        lastModificationDate = currentModificationDate

        return fetchSortedFiles(count: count, usingCache: cacheEnabled)
    }

    // Invalidate the cache if needed, for example when a file is added or removed
    func invalidate() {
        lastModificationDate = nil
        cacheStorage.empty()
    }
    
    func renew() {
        update(cacheStorage)
    }
}

private extension FileCachingProxy {
    func update(_ storage: URLCacheStorage<File>) {
        guard
            let filePaths = try? fileManager.contentsOfDirectory(atPath: fileDirectory.path)
        else {
            Logger.log(message: "Cannot access to saved file")
            return
        }

        filePaths.forEach { fileName in
            let filePath = fileDirectory.appendingPathComponent(fileName)
            
            guard storage.get(filePath) == nil else {
                return
            }
            
            guard let file = fileFactory(fileManager, filePath) else {
                return
            }
            
            storage.store(file, at: filePath)
        }
    }
    
    func fetchSortedFiles(count: Int, usingCache: Bool) -> [File] {
        let files: [File]
        if usingCache {
            files = cacheStorage.all.sorted()
        } else {
            guard let filePaths = try? fileManager.contentsOfDirectory(atPath: fileDirectory.path) else {
                Logger.log(message: "Cannot access to saved file")
                return []
            }
            
            files = filePaths
                .map { fileName in
                    let filePath = fileDirectory.appendingPathComponent(fileName)
                    return fileFactory(fileManager, filePath)
                }
                .compactMap({$0})
        }
        
        return count == 0 ? files : Array(files.prefix(count))
    }
}
