//
//  CapturePhotoOutputProcessorTests.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/19.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class CapturePhotoOutputProcessorTests: XCTestCase {
    var photoOutput: MockAespaPhotoOutputRepresentable!
    
    override func setUpWithError() throws {
        photoOutput = MockAespaPhotoOutputRepresentable()
    }
    
    override func tearDownWithError() throws {
        photoOutput = nil
    }
    
    func testCapture() throws {
        let setting = AVCapturePhotoSettings()
        let delegate = MockDelegate()
        let processor = CapturePhotoProcessor(setting: setting, delegate: delegate)
        
        stub(photoOutput) { proxy in
            when(proxy.capturePhoto(with: equal(to: setting), delegate: equal(to: delegate))).thenDoNothing()
            when(proxy.getConnection(with: equal(to: .video))).thenReturn(MockAespaCaptureConnectionRepresentable())
        }
        
        try processor.process(photoOutput)
        verify(photoOutput)
            .capturePhoto(with: equal(to: setting), delegate: equal(to: delegate))
            .with(returnType: Void.self)
        
        verify(photoOutput)
            .getConnection(with: equal(to: .video))
            .with(returnType: AespaCaptureConnectionRepresentable?.self)
    }
}

fileprivate class MockDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        return
    }
}
