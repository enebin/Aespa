//
//  AespaSessionTests.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/11.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class AespaSessionTests: XCTestCase {
    var aespaSession: AespaSession!
    var mockCore: MockAespaCoreSession!
    var mockRecorder: MockAespaCoreRecorder!
    var mockFileManager: FileManager!
    var mockAlbumManager: MockAespaCoreAlbumManager!

    override func setUpWithError() throws {
        let option = AespaOption(albumName: "default")
        
        mockCore = .init(option: option)
        mockRecorder = .init(core: mockCore)
        mockFileManager = .init()
        mockAlbumManager = .init(albumName: "default")
        
        aespaSession = AespaSession(
            option: option,
            session: mockCore,
            recorder: mockRecorder,
            fileManager: mockFileManager,
            albumManager: mockAlbumManager)
        
        let matcher = ParameterMatcher() as ParameterMatcher<AespaSessionTuning>

        stub(mockCore) { proxy in
            when(
                proxy.run(ParameterMatcher<AespaSessionTuning>())
            ).thenDoNothing()
        }
    }

    func testExample() throws {
        try aespaSession.startSession()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension AespaSessionTests {
    func equal(to value: AespaSessionTuning) -> ParameterMatcher<AespaSessionTuning> {
        return ParameterMatcher { tested in
            type(of: value) == type(of: tested)
        }
    }
}
