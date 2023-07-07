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
        
        XCTAssertEqual(videoFile.creationDate, date)
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
        let data = mockImage.data
        let date = Date()
        let photoFile = PhotoFileGenerator.generate(data: data, date: date)
        
        XCTAssertEqual(photoFile.creationDate, date)
        XCTAssertNotNil(photoFile.image) // Thumbnail should be generated when init
    }
}
