//
//  AespaVideoContext.swift
//  
//
//  Created by 이영빈 on 2023/06/22.
//

import Foundation
import AVFoundation

class AespaVideoContext {
    var isRecording: Bool = false
    
    func then(_ command: OptionCommand, for session: AespaCoreSession) throws -> AespaVideoContext {
        switch command {
        case .mute:
            try mute(session)
        case .unmute:
            try unmute(session)
        case .autofocusing(let mode):
            try setAutofocusing(session, mode: mode)
        case .quality(let preset):
            try setQuality(session, to: preset)
        case .position(let position, let devicePreference):
            try setPosition(session, to: position, devicePreference: devicePreference)
        case .orientation(let orientation):
            try setOrientation(session, to: orientation)
        case .stabilization(let mode):
            try setStabilization(session, mode: mode)
        case .zoom(let factor):
            try zoom(session, factor: factor)
        case .torch(let mode, let level):
            try setTorch(session, mode: mode, level: level)
        }
        
        return self
    }
    
    func startRecording(filePath: URL, recorder: AespaCoreRecorder) throws {
        try recorder.startRecording(in: filePath)
        
        isRecording = true
    }
    
    func stopRecording(recorder: AespaCoreRecorder) async throws -> URL {
        let filePath = try await recorder.stopRecording()
        
        isRecording = false
        return filePath
    }
}

extension AespaVideoContext {
    enum OptionCommand {
        case mute
        case unmute
        case quality(AVCaptureSession.Preset)
        case position(AVCaptureDevice.Position, AVCaptureDevice.DeviceType?)
        case orientation(AVCaptureVideoOrientation)
        case stabilization(AVCaptureVideoStabilizationMode)
        case autofocusing(AVCaptureDevice.FocusMode)
        case zoom(CGFloat)
        case torch(AVCaptureDevice.TorchMode, Float)
    }
}

private extension AespaVideoContext {
    func mute(_ session: AespaCoreSession) throws {
        let tuner = AudioTuner(isMuted: true)
        try session.run(tuner)
    }

    func unmute(_ session: AespaCoreSession) throws {
        let tuner = AudioTuner(isMuted: false)
        try session.run(tuner)
    }

    func setQuality(_ session: AespaCoreSession, to preset: AVCaptureSession.Preset) throws {
        let tuner = QualityTuner(videoQuality: preset)
        try session.run(tuner)
    }

    func setPosition(
        _ session: AespaCoreSession,
        to position: AVCaptureDevice.Position,
        devicePreference: AVCaptureDevice.DeviceType?
    ) throws {
        let tuner = CameraPositionTuner(position: position,
                                        devicePreference: devicePreference)
        try session.run(tuner)
    }

    func setOrientation(_ session: AespaCoreSession, to orientation: AVCaptureVideoOrientation) throws {
        let tuner = VideoOrientationTuner(orientation: orientation)
        try session.run(tuner)
    }

    func setStabilization(_ session: AespaCoreSession, mode: AVCaptureVideoStabilizationMode) throws {
        let tuner = VideoStabilizationTuner(stabilzationMode: mode)
        try session.run(tuner)
    }

    func setAutofocusing(_ session: AespaCoreSession, mode: AVCaptureDevice.FocusMode) throws {
        let tuner = AutoFocusTuner(mode: mode)
        try session.run(tuner)
    }

    func zoom(_ session: AespaCoreSession, factor: CGFloat) throws {
        let tuner = ZoomTuner(zoomFactor: factor)
        try session.run(tuner)
    }

    func setTorch(_ session: AespaCoreSession, mode: AVCaptureDevice.TorchMode, level: Float) throws {
        let tuner = TorchTuner(level: level, torchMode: mode)
        try session.run(tuner)
    }
}
