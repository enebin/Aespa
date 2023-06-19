//
//  MockFileManager.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/18.
//

import Foundation

class MockFileManager: FileManager {
    var urlsStub: [URL]?
    
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
}
