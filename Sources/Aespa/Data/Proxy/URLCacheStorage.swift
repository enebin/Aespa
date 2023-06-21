//
//  URLCacheStorage.swift
//  
//
//  Created by 이영빈 on 2023/06/20.
//

import Foundation

protocol URLCaching<File> {
    associatedtype File
    
    func get(_ url: URL) -> File?
    func store(_ file: File, at filePath: URL)
    func empty()
    
    var all: [File] { get }
}

final class URLCacheStorage<File>: URLCaching {
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
