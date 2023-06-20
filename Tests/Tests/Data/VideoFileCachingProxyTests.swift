//
//  VideoFileCachingProxyTests.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/19.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class VideoFileCachingProxyTests: XCTestCase {
    var sut: VideoFileCachingProxy<MockURLCaching<VideoFile>>!
    
    var mockCache: MockURLCaching<VideoFile>!
    var mockFileManager: MockFileManager!

    override func setUpWithError() throws {
        mockFileManager = MockFileManager()
        mockCache = MockURLCaching<VideoFile>()
        
        // Mock file maanager simulates like it has the `givenVideoFile`
        mockFileManager.urlsStub = [givenDirectoryPath]
        mockFileManager.attributesOfItemStub = givenAttributes
        mockFileManager.contentsOfDirectoryStub = [givenVideoFile.path.lastPathComponent]
        
        // Default stub
        let expectedVideoFile = givenVideoFile
        let expectedFilePath = givenVideoFile.path
        stub(mockCache) { proxy in
            when(proxy.store(equal(to: expectedVideoFile), at: equal(to: expectedFilePath))).thenDoNothing()
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(expectedVideoFile)
            when(proxy.all.get).thenReturn([expectedVideoFile])
            when(proxy.empty()).thenDoNothing()
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        mockFileManager = nil
    }
    
    func testFetchWithoutCount() {
        let givenFiles = [
            givenVideoFile.path.lastPathComponent + "1",
            givenVideoFile.path.lastPathComponent + "2",
            givenVideoFile.path.lastPathComponent + "3"
        ]
        
        mockFileManager.contentsOfDirectoryStub = givenFiles
        
        sut = VideoFileCachingProxy(albumDirectory: givenAlbumDirectory,
                                    enableCaching: false,
                                    fileManager: mockFileManager,
                                    cacheStorage: mockCache)
        
        let fetchedFiles = sut.fetch()
        XCTAssertEqual(fetchedFiles.count, givenFiles.count)
    }
    
    func testFetchWithCount() {
        let givenFiles = [
            givenVideoFile.path.lastPathComponent + "1",
            givenVideoFile.path.lastPathComponent + "2",
            givenVideoFile.path.lastPathComponent + "3"
        ]
        
        mockFileManager.contentsOfDirectoryStub = givenFiles
        
        sut = VideoFileCachingProxy(albumDirectory: givenAlbumDirectory,
                                    enableCaching: false,
                                    fileManager: mockFileManager,
                                    cacheStorage: mockCache)
        
        let fetchedFiles = sut.fetch(count: 2)
        XCTAssertEqual(fetchedFiles.count, 2)
    }
    
    func testInvalidate() {
        sut = VideoFileCachingProxy(albumDirectory: givenAlbumDirectory,
                                    enableCaching: true,
                                    fileManager: mockFileManager,
                                    cacheStorage: mockCache)
        
        sut.invalidate()
        
        XCTAssertNil(sut.lastModificationDate)
        verify(mockCache)
            .empty()
            .with(returnType: Void.self)
    }
    
    func testProxyCache() {
        let expectedVideoFile = givenVideoFile
        let expectedFilePath = givenVideoFile.path
        let modificationDate = Date()

        mockFileManager.contentsOfDirectoryStub = [expectedFilePath.lastPathComponent]
        mockFileManager.attributesOfItemStub = [.modificationDate: modificationDate,
                                                .creationDate: Date()]
        
        // Cache will be filled with a data it has in the `FileManager`
        sut = VideoFileCachingProxy(albumDirectory: givenAlbumDirectory,
                                    enableCaching: true,
                                    fileManager: mockFileManager,
                                    cacheStorage: mockCache)
        
        // Assume empty cache
        stub(mockCache) { proxy in
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(nil)
            when(proxy.all.get).thenReturn([])
        }
        
        verify(mockCache)
            .get(equal(to: expectedFilePath))
            .with(returnType: VideoFile?.self)
        
        // Assume cache filled
        stub(mockCache) { proxy in
            when(proxy.get(equal(to: expectedFilePath))).thenReturn(expectedVideoFile)
            when(proxy.all.get).thenReturn([expectedVideoFile])
        }
        
        let fetchedFiles = sut.fetch(count: 1)

        verify(mockCache, times(1)) // Only includes previous invoke
            .store(equal(to: expectedVideoFile), at: equal(to: expectedFilePath))
            .with(returnType: Void.self)
        
        XCTAssertEqual(sut.lastModificationDate, modificationDate)
        XCTAssertEqual(fetchedFiles.first, expectedVideoFile, "Fetched file should match the initially cached file")
    }

    func testProxyNotUsingCache() {
        let expectedVideoFile = givenVideoFile
        let expectedFilePath = givenVideoFile.path
        
        // Cache shouldn't be filled with a data it has in the `FileManager`
        sut = VideoFileCachingProxy(albumDirectory: givenAlbumDirectory,
                                    enableCaching: false,
                                    fileManager: mockFileManager,
                                    cacheStorage: mockCache)

        let fetchedFiles = sut.fetch(count: 1)
        
        verify(mockCache, never())
            .store(any(VideoFile.self), at: any(URL.self))

        verify(mockCache, never())
            .get(any(URL.self))
        
        verify(mockCache, never())
            .all.get()
        
        XCTAssertTrue(mockFileManager.contentsOfDirectoryCalled)
        XCTAssertEqual(fetchedFiles.first, expectedVideoFile, "Fetched file should match the initially cached file")
    }
}

fileprivate extension VideoFileCachingProxyTests {
    var givenFilename: String {
        "File"
    }
    
    var givenDirectoryPath: URL {
        URL(fileURLWithPath: "/path/to/mock/", isDirectory: true)
    }
    
    var givenAlbumDirectory: URL {
        URL(fileURLWithPath: "\(givenDirectoryPath.relativePath)/Test", isDirectory: true)
    }

    var givenVideoFile: VideoFile {
        VideoFile(generatedDate: Date(),
                  path: givenAlbumDirectory.appendingPathComponent(givenFilename))
    }

    var givenAttributes: [FileAttributeKey: Any] {
        [.modificationDate: Date(), .creationDate: Date()]
    }
}
