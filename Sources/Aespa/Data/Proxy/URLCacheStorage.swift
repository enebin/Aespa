//
//  URLCacheStorage.swift
//  
//
//  Created by 이영빈 on 2023/06/20.
//

import Foundation

class URLCacheStorage<File> {
    private var storage: [URL: File]
    
    init() {
        self.storage = [:]
    }
    
    func get(_ filePath: URL) -> File? {
        storage[filePath]
    }
    
    func store(_ file: File, at filePath: URL) {
        storage[filePath] = file
    }
    
    func empty() {
        storage.removeAll()
    }
    
    var all: [File] {
        Array(storage.values)
    }
}
