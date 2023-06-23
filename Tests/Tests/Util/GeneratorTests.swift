//
//  GeneratorTests.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/23.
//

import XCTest

@testable import Aespa


final class GeneratorTests: XCTestCase {
    var mockVideo: MockVideo!
    var mockImage: MockImage!
    
    override func setUpWithError() throws {
        mockVideo = MockVideo()
        mockImage = MockImage()
    }
    
    override func tearDownWithError() throws {
        mockVideo = nil
        mockImage = nil
    }
    
    func testVideoFile_generate() {
        guard let path = mockVideo.path else {
            XCTFail("Unable to get the mock video path")
            return
        }
        
        let date = Date()
        let videoFile = VideoFileGenerator.generate(with: path, date: date)
        
        XCTAssertEqual(videoFile.generatedDate, date)
        XCTAssertEqual(videoFile.path, path)
        XCTAssertNotNil(videoFile.thumbnail) // Thumbnail should be generated when init
    }
    
    func testVideoFile_generateThumbnail() {
        guard let path = mockVideo.path else {
            XCTFail("Unable to get the mock video path")
            return
        }

        let thumbnail = VideoFileGenerator.generateThumbnail(for: path)
        
        XCTAssertNotNil(thumbnail)
    }
    
    func testPhotoFile_generate() {
        let path = mockImage.path
        
        let date = Date()
        let photoFile = PhotoFileGenerator.generate(with: path, date: date)
        
        XCTAssertEqual(photoFile.generatedDate, date)
        XCTAssertEqual(photoFile.path, path)
        XCTAssertNotNil(photoFile.thumbnail) // Thumbnail should be generated when init
    }
    
    func testPhotoFile_generateThumbnail() {
        let path = mockImage.path

        let thumbnail = PhotoFileGenerator.generateThumbnail(for: path)
        
        XCTAssertNotNil(thumbnail)
    }
}
