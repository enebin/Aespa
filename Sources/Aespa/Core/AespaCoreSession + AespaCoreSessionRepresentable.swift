//
//  AespaCoreSession + AespaCoreSessionRepresentable.swift
//  
//
//  Created by Young Bin on 2023/06/08.
//

import Foundation
import AVFoundation

public protocol AespaCoreSessionRepresentable: AVCaptureSession {
    var audioDeviceInput: AVCaptureDeviceInput? { get }
    var videoDeviceInput: AVCaptureDeviceInput? { get }
    var movieFileOutput: AVCaptureMovieFileOutput? { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    
    func addMovieInput() throws -> Self
    func removeMovieInput() -> Self
    func addAudioInput() throws -> Self
    func removeAudioInput() -> Self
    func addMovieFileOutput() throws -> Self
    func setCameraPosition(to position: AVCaptureDevice.Position) throws
    func setVideoQuality(to preset: AVCaptureSession.Preset)
}

extension AespaCoreSession: AespaCoreSessionRepresentable {
    // MARK: - Vars
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
    
    // MARK: - Input and output
    @discardableResult
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
    
    @discardableResult
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
    
    @discardableResult
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
    
    // MARK: - Option related
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
