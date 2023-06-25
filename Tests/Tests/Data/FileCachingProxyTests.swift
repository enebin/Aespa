//
//  FileCachingProxyTests.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/19.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class FileCachingProxyTests: XCTestCase {
    typealias File = String
    
    var sut: FileCachingProxy<File>!
    
    var mockCache: MockURLCacheStorage<File>!
    var mockFileManager: MockFileManager!

    let fileFactory: (FileManager, URL) -> String? = { (_, url) in
        url.lastPathComponent
    }
    
    override func setUpWithError() throws {
        mockFileManager = MockFileManager()
        mockCache = MockURLCacheStorage<File>()
        
        // Mock file maanager simulates like it has the `givenFile`
        mockFileManager.urlsStub = [givenDirectoryPath]
        mockFileManager.contentsOfDirectoryStub = [givenFile]
        
        // Default stub
        let expectedFile = givenFile
        let expectedFilePath = givenFilePath
        stub(mockCache) { proxy in
            when(proxy.store(equal(to: expectedFile), at: equal(to: expectedFilePath))).thenDoNothing()
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(expectedFile)
            when(proxy.all.get).thenReturn([expectedFile])
            when(proxy.empty()).thenDoNothing()
        }
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockFileManager = nil
    }
    
    func testFetchWithoutCount() {
        let givenFiles = ["File1.txt", "File2.txt", "File3.txt"]
        
        mockFileManager.contentsOfDirectoryStub = givenFiles
        
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: false,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        
        let fetchedFiles = sut.fetch()
        XCTAssertEqual(fetchedFiles.count, givenFiles.count)
    }
    
    func testFetchWithCount() {
        let givenFiles = ["File1.txt", "File2.txt", "File3.txt"]
        
        mockFileManager.contentsOfDirectoryStub = givenFiles
        
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: false,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        
        let fetchedFiles = sut.fetch(count: 2)
        XCTAssertEqual(fetchedFiles.count, 2)
    }
    
    func testInvalidate() {
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: true,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        
        sut.invalidate()
        
        XCTAssertNil(sut.lastModificationDate)
        verify(mockCache).empty().with(returnType: Void.self)
    }
    
    func testRenew() {
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: true,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        // Given a file
        mockFileManager.contentsOfDirectoryStub = [givenFile]
        
        // Given empty cache
        stub(mockCache) { proxy in
            when(proxy.get(any(URL.self))).thenReturn(nil)
            when(proxy.all.get).thenReturn([])
        }
        
        print(givenFilePath)
        let expectedFile = givenFile
        let expectedFilePath = givenFilePath
        stub(mockCache) { proxy in
            when(proxy.store(equal(to: expectedFile), at: equal(to: expectedFilePath))).thenDoNothing()
        }
        
        // When renew is called
        sut.renew()
        
        // Then cache should have been updated
        verify(mockCache)
            .store(equal(to: expectedFile), at: equal(to: expectedFilePath))
            .with(returnType: Void.self)
    }
    
    func testProxyCache() {
        let expectedFile = givenFile
        let expectedFilePath = givenFilePath
        let modificationDate = Date()
        
        mockFileManager.contentsOfDirectoryStub = [expectedFile]
        mockFileManager.attributesOfItemStub = [.modificationDate: modificationDate, .creationDate: Date()]
        
        // Cache will be filled with a data it has in the `FileManager`
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: true,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        
        // Given empty cache
        stub(mockCache) { proxy in
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(nil)
            when(proxy.all.get).thenReturn([])
        }
        
        // When renew the cache
        sut.renew()
        
        // Then
        verify(mockCache).get(equal(to: expectedFilePath)).with(returnType: File?.self)
        verify(mockCache).store(equal(to: expectedFile), at: equal(to: expectedFilePath)).with(returnType: Void.self)
        
        // Given cache filled
        stub(mockCache) { proxy in
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(expectedFile)
            when(proxy.all.get).thenReturn([expectedFile])
        }
        
        // When fetch the files
        let fetchedFiles = sut.fetch(count: 1)
        
        // Then...
        verify(mockCache, times(1)) // Only includes previous invoke - which means store's not called additionally
            .store(equal(to: expectedFile), at: equal(to: expectedFilePath)).with(returnType: Void.self)
        
        XCTAssertEqual(sut.lastModificationDate, modificationDate)
        XCTAssertEqual(fetchedFiles.first, expectedFile, "Fetched file should match the initially cached file")
    }
    
    func testProxyNotUsingCache() {
        let expectedFile = givenFile
        
        // Cache shouldn't be filled with a data it has in the `FileManager`
        sut = FileCachingProxy(fileDirectory: givenAlbumDirectory,
                               enableCaching: false,
                               fileManager: mockFileManager,
                               cacheStorage: mockCache,
                               fileFactory: fileFactory)
        
        let fetchedFiles = sut.fetch(count: 1)
        
        verify(mockCache, never()).store(any(File.self), at: any(URL.self))
        verify(mockCache, never()).get(any(URL.self))
        verify(mockCache, never()).all.get()
        
        XCTAssertTrue(mockFileManager.contentsOfDirectoryCalled)
        XCTAssertEqual(fetchedFiles.first, expectedFile, "Fetched file should match the initially cached file")
    }
    
    var givenFile: File {
        "File.txt"
    }
    
    var givenDirectoryPath: URL {
        URL(fileURLWithPath: "/path/to/mock/", isDirectory: true)
    }
    
    var givenAlbumDirectory: URL {
        URL(fileURLWithPath: "\(givenDirectoryPath.relativePath)/Test", isDirectory: true)
    }
    
    var givenFilePath: URL {
        givenAlbumDirectory.appendingPathComponent(givenFile)
    }
    
    var givenAttributes: [FileAttributeKey: Any] {
        [.modificationDate: Date(), .creationDate: Date()]
    }
}

