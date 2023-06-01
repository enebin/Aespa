//
//  File.swift
//  
//
//  Created by Young Bin on 2023/05/28.
//

import AVFoundation

extension AVCaptureConnection {
    func setOrientation(to orientation: AVCaptureVideoOrientation) {
        self.videoOrientation = orientation
    }
    
    func setStabilizationMode(to mode: AVCaptureVideoStabilizationMode) {
        self.preferredVideoStabilizationMode = mode
    }
}

extension AVCaptureDevice.Position {
    var chooseBestCamera: AVCaptureDevice? {
        let position = self
        
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: position) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            return device
        } else {
            return nil
        }
    }
}

extension AVCaptureDeviceInput {
    func setZoomFactor(factor: CGFloat) {
        let videoDevice = self

        do {
            try videoDevice.device.lockForConfiguration()
            
            videoDevice.device.videoZoomFactor = factor
            
            videoDevice.device.unlockForConfiguration()
        } catch {
            videoDevice.device.unlockForConfiguration()
        }
    }
}

// MARK: - Session related
extension AVCaptureSession {
    var audioDevice: AVCaptureDeviceInput? {
        return self.inputs
            .compactMap { $0 as? AVCaptureDeviceInput } // Get inputs
            .filter { $0.device.hasMediaType(.audio) } // Find audio input
            .first
    }
    
    var videoDevice: AVCaptureDeviceInput? {
        return self.inputs
            .compactMap { $0 as? AVCaptureDeviceInput } // Get inputs
            .filter { $0.device.hasMediaType(.video) } // Find video input
            .first
    }
    
    var movieOutput: AVCaptureMovieFileOutput? {
        let session = self
        let output = session.outputs.first as? AVCaptureMovieFileOutput
        
        return output
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        let session = self
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.connection?.videoOrientation = .portrait // Fixed value for now
        
        return previewLayer
    }
}

// MARK: - Add/remove in/outputs
extension AVCaptureSession {
    func addMovieInput() throws -> Self {
        let session = self
        session.beginConfiguration()
        
        // Add microphone input
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        let videoInput = try AVCaptureDeviceInput(device: videoDevice)
        guard session.canAddInput(videoInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        session.addInput(videoInput)
        
        session.commitConfiguration()
        return self
    }
    
    func connectMovieOutput() throws -> Self {
        let session = self
        
        guard session.movieOutput == nil else {
            throw AespaError.device(reason: .outputAlreadyExists)
        }
        
        session.beginConfiguration()
        
        let fileOutput = AVCaptureMovieFileOutput()
        if session.canAddOutput(fileOutput) {
            session.addOutput(fileOutput)
        } else {
            throw AespaError.device(reason: .unableToSetOutput)
        }
        
        session.commitConfiguration()
        return self
    }
    
    func addAudioInput() throws -> Self {
        let session = self
        session.beginConfiguration()
        
        // Add microphone input
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        
        guard session.canAddInput(audioInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }
        
        session.addInput(audioInput)
        
        session.commitConfiguration()
        return self
    }
    
    func removeAudioInput() -> Self {
        let session = self
        session.beginConfiguration()
        
        if let audioDevice {
            session.removeInput(audioDevice)
        }
        
        session.commitConfiguration()
        return self
    }
}

// MARK: - Options
extension AVCaptureSession {
    func setCameraPosition(to position: AVCaptureDevice.Position) throws {
        let session = self
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        if let videoDevice {
            session.removeInput(videoDevice)
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

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        session.sessionPreset = preset
    }
}
