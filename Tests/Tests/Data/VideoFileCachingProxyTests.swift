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
    var sut: VideoFileCachingProxy!
    var mockFileManager: MockFileManager!
    var expectedVideoFile: VideoFile { VideoFile(generatedDate: Date(), path: URL(fileURLWithPath: "/path/to/mock/file")) }
    var attributes: [FileAttributeKey: Any] { [.modificationDate: Date(), .creationDate: Date()] }

    override func setUpWithError() throws {
        mockFileManager = MockFileManager()
        mockFileManager.urlsStub = [expectedVideoFile.path]
        mockFileManager.attributesOfItemStub = attributes
        mockFileManager.contentsOfDirectoryStub = ["/path/to/mock/file"]

        sut = VideoFileCachingProxy(albumName: "Test", enableCaching: true, fileManager: mockFileManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockFileManager = nil
    }

    func testFetch_withCacheEnabledAndUnmodifiedFileSystem_returnsCachedFiles() {
        let expectedVideoFile = VideoFile(generatedDate: Date(), path: URL(fileURLWithPath: "/path/to/mock/file"))
        
        mockFileManager.urlsStub = [expectedVideoFile.path]
        mockFileManager.attributesOfItemStub = attributes
        
        _ = sut.fetch(count: 0) // Initial fetch to populate the cache

        let fetchedFiles = sut.fetch(count: 1)
        XCTAssertEqual(fetchedFiles.first, expectedVideoFile,
                       "Fetched file should match the initially cached file when the file system is not modified")
    }

    func testFetch_withCacheDisabled_returnsFilesFromFileSystem() {
        sut = VideoFileCachingProxy(albumName: "Test", enableCaching: false, fileManager: mockFileManager)
        mockFileManager.urlsStub = [expectedVideoFile.path]


        let fetchedFiles = sut.fetch(count: 1)
        XCTAssertEqual(fetchedFiles.first, expectedVideoFile,
                       "Fetched file should match the file from file system when caching is disabled")
    }

    func testFetch_withCacheEnabledAndModifiedFileSystem_updatesCacheAndReturnsUpdatedFiles() {
        let initialVideoFile = VideoFile(generatedDate: Date(), path: URL(fileURLWithPath: "/path/to/mock/file"))
        mockFileManager.urlsStub = [initialVideoFile.path]
        mockFileManager.attributesOfItemStub = attributes
        _ = sut.fetch(count: 0) // Initial fetch to populate the cache

        mockFileManager.urlsStub = [expectedVideoFile.path]
        mockFileManager.attributesOfItemStub = [.modificationDate: Date().addingTimeInterval(1)] // Ensure modification date is different

        let fetchedFiles = sut.fetch(count: 1)
        XCTAssertEqual(fetchedFiles.first, expectedVideoFile,
                       "Fetched file should match the updated file from file system when the file system is modified")
    }
}
