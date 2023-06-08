//
//  AespaCoreSessionManager.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import UIKit
import Combine
import Foundation
import AVFoundation

class AespaCoreSession: AVCaptureSession {
    var option: AespaOption
    
    init(option: AespaOption) {
        self.option = option
    }
    
    func run(_ tuner: some AespaSessionTuning) throws {
        if tuner.needTransaction { self.beginConfiguration() }
        defer {
            if tuner.needTransaction { self.commitConfiguration() }
        }
        
        try tuner.tune(self)
    }
    
    func run(_ tuner: some AespaDeviceTuning) throws {
        guard let device = self.videoDeviceInput?.device else {
            throw AespaError.device(reason: .invalid)
        }
        
        if tuner.needLock { try device.lockForConfiguration() }
        defer {
            if tuner.needLock { device.unlockForConfiguration() }
        }
        
        try tuner.tune(device)
    }
    
    func run(_ tuner: some AespaConnectionTuning) throws {
        guard let connection = self.connections.first else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        try tuner.tune(connection)
    }
    
    func run(_ processor: some AespaFileOutputProcessing) throws {
        guard let output = self.movieFileOutput else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        try processor.process(output)
    }
}

extension AespaCoreSession: AespaCoreSessionRepresentable {
    // MARK: Vars
    var audioDeviceInput: AVCaptureDeviceInput? {
        return self.inputs
            .compactMap { $0 as? AVCaptureDeviceInput } // Get inputs
            .filter { $0.device.hasMediaType(.audio) } // Find audio input
            .first
    }
    
    var videoDeviceInput: AVCaptureDeviceInput? {
        return self.inputs
            .compactMap { $0 as? AVCaptureDeviceInput } // Get inputs
            .filter { $0.device.hasMediaType(.video) } // Find video input
            .first
    }
    
    var movieFileOutput: AVCaptureMovieFileOutput? {
        let output = self.outputs.first as? AVCaptureMovieFileOutput
        
        return output
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self)
        previewLayer.connection?.videoOrientation = .portrait // Fixed value for now
        
        return previewLayer
    }
    
    // MARK: Input and output
    func addMovieInput() throws -> Self {
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        let videoInput = try AVCaptureDeviceInput(device: videoDevice)
        guard self.canAddInput(videoInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        self.addInput(videoInput)
        
        return self
    }
    
    func removeMovieInput() -> Self {
        guard
            let videoDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            return self
        }

        self.removeInput(videoInput)
        
        return self
    }
    
    @discardableResult
    func addAudioInput() throws -> Self {
        // Add microphone input
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        
        guard self.canAddInput(audioInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        self.addInput(audioInput)
        return self
    }
    
    @discardableResult
    func removeAudioInput() -> Self {
        if let audioDeviceInput {
            self.removeInput(audioDeviceInput)
        }
        
        return self
    }
    
    func addMovieFileOutput() throws -> Self {
        guard self.movieFileOutput == nil else {
            // return itself if output is already set
           return self
        }
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard self.canAddOutput(fileOutput) else {
            throw AespaError.device(reason: .unableToSetOutput)
        }
        
        self.addOutput(fileOutput)
        
        return self
    }
    
    // MARK: Option related
    func setCameraPosition(to position: AVCaptureDevice.Position) throws {
        let session = self
        
        if let videoDeviceInput {
            session.removeInput(videoDeviceInput)
        }
        
        guard let device = position.chooseBestCamera else {
            throw AespaError.device(reason: .invalid)
        }
        
        let deviceInput = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        } else {
            throw AespaError.device(reason: .unableToSetInput)
        }
    }
    
    func setVideoQuality(to preset: AVCaptureSession.Preset) {
        let session = self
        
        session.sessionPreset = preset
    }
}
