//
//  AVFoundation + Extension.swift
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
        let output = self.outputs.first as? AVCaptureMovieFileOutput
        
        return output
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self)
        previewLayer.connection?.videoOrientation = .portrait // Fixed value for now
        
        return previewLayer
    }
}

// MARK: - Add/remove in/outputs
extension AVCaptureSession {
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
    
    func addMovieFileOutput() throws -> Self {
        guard self.movieOutput == nil else {
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
        if let audioDevice {
            self.removeInput(audioDevice)
        }
        
        return self
    }
}

// MARK: - Options
extension AVCaptureSession {
    func setCameraPosition(to position: AVCaptureDevice.Position) throws {
        let session = self
        
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
        
        session.sessionPreset = preset
    }
}
