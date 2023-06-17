//
//  DeviceTunerTests.swift
//  Aespa-iOS-testTests
//
//  Created by 이영빈 on 2023/06/16.
//

import XCTest
import AVFoundation

import Cuckoo

@testable import Aespa

final class DeviceTunerTests: XCTestCase {
    private var device: MockAespaCaptureDeviceRepresentable!
    
    override func setUpWithError() throws {
        device = MockAespaCaptureDeviceRepresentable()
    }

    override func tearDownWithError() throws {
        device = nil
    }

    func testAutoFocusTuner() throws {
        let mode = AVCaptureDevice.FocusMode.locked
        let tuner = AutoFocusTuner(mode: mode)
        
        stub(device) { proxy in
            when(proxy.isFocusModeSupported(equal(to: mode))).thenReturn(true)
            when(proxy.setFocusMode(equal(to: mode))).then { mode in
                when(proxy.focusMode.get).thenReturn(mode)
            }
        }
        
        try tuner.tune(device)
        verify(device)
            .setFocusMode(equal(to: mode))
            .with(returnType: Void.self)
        
        XCTAssertEqual(device.focusMode, mode)
    }
    
    func testZoomTuner() throws {
        let factor = 1.23
        let tuner = ZoomTuner(zoomFactor: factor)
        
        stub(device) { proxy in
            when(proxy.setZoomFactor(equal(to: factor))).then { factor in
                when(proxy.videoZoomFactor.get).thenReturn(factor)
            }
        }
        
        tuner.tune(device)
        verify(device)
            .setZoomFactor(equal(to: factor))
            .with(returnType: Void.self)
        
        XCTAssertEqual(device.videoZoomFactor, factor)
    }
    
    func testTorchTuner() throws {
        let level: Float = 0.15
        let mode: AVCaptureDevice.TorchMode = .auto
        let tuner = TorchTuner(level: level, torchMode: mode)
        
        stub(device) { proxy in
            when(proxy.hasTorch.get).thenReturn(true)
            when(proxy.setTorchMode(equal(to: mode))).thenDoNothing()
            when(proxy.setTorchModeOn(level: level)).thenDoNothing()
        }
        
        try tuner.tune(device)
        verify(device)
            .setTorchMode(equal(to: mode))
            .with(returnType: Void.self)
        
        verify(device)
            .setTorchModeOn(level: level)
            .with(returnType: Void.self)
    }
}

class MockDevice: AVCaptureDevice {
}
