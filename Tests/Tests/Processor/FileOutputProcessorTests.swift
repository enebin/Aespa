//
//  FileOutputProcessorTests.swift
//  Aespa-iOS-testTests
//
//  Created by 이영빈 on 2023/06/16.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class FileOutputProcessorTests: XCTestCase {
    var fileOutput: MockAespaFileOutputRepresentable!

    override func setUpWithError() throws {
        fileOutput = MockAespaFileOutputRepresentable()
    }

    override func tearDownWithError() throws {
        fileOutput = nil
    }

    func testStartRecording() throws {
        let url = URL(string: "/data/some.mp4")!
        let delegate = MockDelegate()
        let processor = StartRecordProcessor(filePath: url, delegate: delegate)
        
        stub(fileOutput) { proxy in
            when(proxy.getConnection(
                with: equal(to: AVMediaType.video))
            ).thenReturn(MockAespaCaptureConnectionRepresentable())
            
            when(proxy.startRecording(
                to: equal(to: url), recordingDelegate: equal(to: delegate))
            ).thenDoNothing()
        }
        
        try processor.process(fileOutput)
        verify(fileOutput)
            .startRecording(to: equal(to: url), recordingDelegate: equal(to: delegate))
            .with(returnType: Void.self)
    }
    
    func testStopRecording() throws {
        let processor = FinishRecordProcessor()
        
        stub(fileOutput) { proxy in
            when(proxy.stopRecording()).thenDoNothing()
        }
        
        try processor.process(fileOutput)
        verify(fileOutput)
            .stopRecording()
            .with(returnType: Void.self)
    }
}

fileprivate class MockDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {}
}
