//
//  CoreSessionRepresentableTests.swift
//  TestHostAppTests
//
//  Created by Young Bin on 2026/06/10.
//

import XCTest
import AVFoundation

@testable import Aespa

final class CoreSessionRepresentableTests: XCTestCase {
    func testAddCapturePhotoOutputRaisesMaxPhotoQualityPrioritization() throws {
        let session = AespaCoreSession(option: AespaOption(albumName: nil))

        try session.addCapturePhotoOutput()

        XCTAssertEqual(session.photoOutput?.maxPhotoQualityPrioritization, .quality)
    }
}
