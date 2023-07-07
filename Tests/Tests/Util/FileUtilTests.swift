//
//  FileGeneratorTests.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/18.
//

import XCTest
import Photos
import AVFoundation

import Cuckoo

@testable import Aespa

final class FileGeneratorTests: XCTestCase {
    let mockVideo = MockVideo()
    var mockFileManager: MockFileManager!

    override func setUpWithError() throws {
        mockFileManager = MockFileManager()
        mockFileManager.urlsStub = [mockVideo.dirPath]
    }
    
    override func tearDownWithError() throws {
        mockFileManager = nil
    }
    
    func testGenerate() throws {
        let filePath = mockVideo.path!
        let date = Date()
        let file = VideoFileGenerator.generate(with: filePath, date: date)
        
        XCTAssertEqual(file.path, filePath)
        XCTAssertEqual(file.creationDate, date)
    }

    func testGenerateThumbnail() throws {
        let filePath = mockVideo.path!
        let thumbnail = VideoFileGenerator.generateThumbnail(for: filePath)

        XCTAssertNotNil(thumbnail)
    }
    
    func testRequestDirPath() throws {
        let albumName = "Test"
        let dirPath = try FilePathProvider.requestDirectoryPath(from: mockFileManager, directoryName: albumName)
        
        XCTAssertEqual(dirPath.lastPathComponent, albumName)
    }
    
    func testRequestFilePath() throws {
        let albumName = "Test"
        let subDirName = "Sub"
        let fileName = "Testfile"
        let `extension` = "mp4"
        let expectedSuffix = "/\(albumName)/\(subDirName)/\(fileName).\(`extension`)"
        
        let filePath = try FilePathProvider.requestFilePath(
            from: mockFileManager,
            directoryName: albumName,
            subDirectoryName: subDirName,
            fileName: fileName,
            extension: `extension`)
        
        XCTAssertTrue(filePath.absoluteString.hasSuffix(expectedSuffix))
    }
}
