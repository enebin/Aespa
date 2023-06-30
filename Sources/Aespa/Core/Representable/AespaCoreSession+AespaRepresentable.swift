//
//  AespaCoreSession + AespaCoreSessionRepresentable.swift
//  
//
//  Created by Young Bin on 2023/06/08.
//

import Foundation
import AVFoundation

/// `AespaCoreSessionRepresentable` defines a set of requirements for classes or
/// structs that interact with `AVCaptureDeviceInput` and
/// `AVCaptureMovieFileOutput` to setup and configure a camera session for recording videos.
public protocol AespaCoreSessionRepresentable {
    /// The `AVCaptureSession` that coordinates the flow of data from AV input devices to outputs.
    var avCaptureSession: AVCaptureSession { get }

    /// A Boolean value indicating whether the capture session is running.
    var isRunning: Bool { get }

    /// The `AVCaptureDeviceInput` representing the audio input.
    var audioDeviceInput: AVCaptureDeviceInput? { get }

    /// The `AVCaptureDeviceInput` representing the video input.
    var videoDeviceInput: AVCaptureDeviceInput? { get }

    /// The `AVCaptureMovieFileOutput` for the video file output.
    var movieFileOutput: AVCaptureMovieFileOutput? { get }

    /// The `AVCaptureVideoPreviewLayer` for previewing the video being recorded.
    var previewLayer: AVCaptureVideoPreviewLayer { get }

    /// Starts the capture session. This method is synchronous and blocks until the session starts.
    func startRunning()

    /// Stops the capture session. This method is synchronous and blocks until the session stops.
    func stopRunning()

    /// Adds movie input to the recording session.
    /// Throws an error if the operation fails.
    func addMovieInput() throws

    /// Removes movie input from the recording session if it exists.
    func removeMovieInput()

    /// Adds audio input to the recording session.
    /// Throws an error if the operation fails.
    func addAudioInput() throws

    /// Removes audio input from the recording session if it exists.
    func removeAudioInput()

    /// Adds movie file output to the recording session.
    /// Throws an error if the operation fails.
    func addMovieFileOutput() throws

    /// Adds photo file output to the session.
    /// Throws an error if the operation fails.
    func addCapturePhotoOutput() throws

    /// Sets the position of the camera.
    /// Throws an error if the operation fails.
    func cameraPosition(
        to position: AVCaptureDevice.Position,
        device deviceType: AVCaptureDevice.DeviceType?
    ) throws

    /// Sets the video quality preset.
    func videoQuality(to preset: AVCaptureSession.Preset) throws
}

extension AespaCoreSession: AespaCoreSessionRepresentable {
    // MARK: - Vars
    var avCaptureSession: AVCaptureSession { self }

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
        let output = self.outputs.first {
            $0 as? AVCaptureMovieFileOutput != nil
        }

        return output as? AVCaptureMovieFileOutput
    }

    var photoOutput: AVCapturePhotoOutput? {
        let output = self.outputs.first {
            $0 as? AVCapturePhotoOutput != nil
        }

        return output as? AVCapturePhotoOutput
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: self)
        previewLayer.connection?.videoOrientation = .portrait // Fixed value for now

        return previewLayer
    }

    // MARK: - Input and output

    func addMovieInput() throws {
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            throw AespaError.device(reason: .unableToSetInput)
        }

        let videoInput = try AVCaptureDeviceInput(device: videoDevice)
        guard self.canAddInput(videoInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }

        self.addInput(videoInput)
    }

    func removeMovieInput() {
        guard
            let videoDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            return
        }

        self.removeInput(videoInput)
    }

    func addAudioInput() throws {
        // Add microphone input
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            throw AespaError.device(reason: .unableToSetInput)
        }

        let audioInput = try AVCaptureDeviceInput(device: audioDevice)

        guard self.canAddInput(audioInput) else {
            throw AespaError.device(reason: .unableToSetInput)
        }

        self.addInput(audioInput)
    }

    func removeAudioInput() {
        if let audioDeviceInput {
            self.removeInput(audioDeviceInput)
        }
    }

    func addMovieFileOutput() throws {
        guard self.movieFileOutput == nil else {
            // return itself if output is already set
           return
        }

        let fileOutput = AVCaptureMovieFileOutput()
        guard self.canAddOutput(fileOutput) else {
            throw AespaError.device(reason: .unableToSetOutput)
        }

        self.addOutput(fileOutput)
    }

    func addCapturePhotoOutput() throws {
        guard self.photoOutput == nil else {
            // return itself if output is already set
           return
        }

        let photoOutput = AVCapturePhotoOutput()
        guard self.canAddOutput(photoOutput) else {
            throw AespaError.device(reason: .unableToSetOutput)
        }

        self.addOutput(photoOutput)
    }

    // MARK: - Option related
    func cameraPosition(
        to position: AVCaptureDevice.Position,
        device deviceType: AVCaptureDevice.DeviceType?
    ) throws {
        let session = self

        if let videoDeviceInput {
            session.removeInput(videoDeviceInput)
        }

        let device: AVCaptureDevice
        if
            let deviceType,
            let captureDeivce = AVCaptureDevice.default(deviceType, for: .video, position: position)
        {
            device = captureDeivce
        } else if let bestDevice = position.chooseBestCamera {
            device = bestDevice
        } else {
            throw AespaError.device(reason: .invalid)
        }

        let deviceInput = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        } else {
            throw AespaError.device(reason: .unableToSetInput)
        }
    }

    func videoQuality(to preset: AVCaptureSession.Preset) {
        let session = self

        session.sessionPreset = preset
    }
}
