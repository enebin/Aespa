//
//  ConnectionTunerTests.swift
//  Aespa-iOS-testTests
//
//  Created by 이영빈 on 2023/06/16.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class ConnectionTunerTests: XCTestCase {
    var connection: MockAespaCaptureConnectionRepresentable!
    
    override func setUpWithError() throws {
        connection = MockAespaCaptureConnectionRepresentable()
    }
    
    override func tearDownWithError() throws {
        connection = nil
    }
    
    func testOrientationTuner() throws {
        let orientation = AVCaptureVideoOrientation.portrait
        let tuner = VideoOrientationTuner(orientation: orientation)
        
        stub(connection) { proxy in
            when(proxy.setOrientation(to: equal(to: orientation))).then { value in
                when(proxy.videoOrientation.get).thenReturn(orientation)
            }
        }
        
        try tuner.tune(connection)
        verify(connection)
            .setOrientation(to: equal(to: orientation))
            .with(returnType: Void.self)
        
        XCTAssertEqual(connection.videoOrientation, orientation)
    }
    
    func testStabilizationTuner() throws {
        let mode = AVCaptureVideoStabilizationMode.auto
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        
        stub(connection) { proxy in
            when(proxy.setStabilizationMode(to: equal(to: mode))).then { value in
                when(proxy.preferredVideoStabilizationMode.get).thenReturn(mode)
            }
        }
        
        tuner.tune(connection)
        verify(connection)
            .setStabilizationMode(to: equal(to: mode))
            .with(returnType: Void.self)
        
        XCTAssertEqual(connection.preferredVideoStabilizationMode, mode)
    }
}
