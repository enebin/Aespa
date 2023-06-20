//
//  URLCacheStorage.swift
//  
//
//  Created by 이영빈 on 2023/06/20.
//

import Foundation

protocol URLCache {
    associatedtype File
    
    func get(_ url: URL) -> File?
    func store(_ file: File, at filePath: URL)
    func renew(with filePair: [URL: File])
    func empty()
    
    var all: [File] { get }
}

class URLCacheStorage<File>: URLCache {
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
    
    func renew(with filePair: [URL: File]) {
        storage = filePair
    }
    
    func empty() {
        storage.removeAll()
    }
    
    var all: [File] {
        Array(storage.values)
    }
}
