//
//  MockFileManager.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/18.
//

import Foundation

class MockFileManager: FileManager {
    var urlsStub: [URL]?
    var attributesOfItemStub: [FileAttributeKey: Any]?
    
    var contentsOfDirectoryStub: [String]?
    var contentsOfDirectoryCalled: Bool = false
    
    override func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL] {
        urlsStubMethod()
    }
    
    private func urlsStubMethod() -> [URL] {
        guard let urlsStub else {
            fatalError("Stub is not provided")
        }
        return urlsStub
    }
    
    override func createDirectory(
        atPath path: String,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]? = nil
    ) throws {
        return
    }
    
    override func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] {
        try attributesOfItemStubMethod(atPath: path)
    }
    
    private func attributesOfItemStubMethod(atPath path: String) throws -> [FileAttributeKey : Any] {
        guard let attributesOfItemStub else {
            fatalError("Stub is not provided")
        }
        return attributesOfItemStub
    }
    
    override func contentsOfDirectory(atPath path: String) throws -> [String] {
        let result = try contentsOfDirectoryStubMethod(atPath: path)
        contentsOfDirectoryCalled = true
        
        return result
    }
    
    private func contentsOfDirectoryStubMethod(atPath path: String) throws -> [String] {
        guard let contentsOfDirectoryStub else {
            fatalError("Stub is not provided")
        }
        return contentsOfDirectoryStub
    }
}
