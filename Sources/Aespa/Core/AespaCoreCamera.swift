//
//  AespaCoreCamera.swift
//  
//
//  Created by Young Bin on 2023/06/18.
//

import Combine
import Foundation
import AVFoundation

/// Capturing a photo and responsible for notifying the result
nonisolated class AespaCoreCamera: NSObject, @unchecked Sendable {
    private let core: AespaCoreSession

    private let captureLock = NSRecursiveLock()
    private var captureContinuations: [Int64: CheckedContinuation<AVCapturePhoto, Error>] = [:]

    init(core: AespaCoreSession) {
        self.core = core
    }

    func run<T: AespaCapturePhotoOutputProcessing>(processor: T) throws {
        guard let output = core.photoOutput else {
            throw AespaError.session(reason: .cannotFindConnection)
        }

        try processor.process(output)
    }
}

nonisolated extension AespaCoreCamera {
    func capture(
        setting: AVCapturePhotoSettings,
        autoVideoOrientationEnabled: Bool
    ) async throws -> AVCapturePhoto {
        let processor = CapturePhotoProcessor(setting: setting, delegate: self, autoVideoOrientationEnabled: autoVideoOrientationEnabled)
        return try await withCheckedThrowingContinuation { continuation in
            setContinuation(continuation, for: setting.uniqueID)
            
            do {
                try run(processor: processor)
            } catch {
                _ = removeContinuation(for: setting.uniqueID)
                continuation.resume(throwing: error)
            }
        }
    }
}

nonisolated extension AespaCoreCamera: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        Logger.log(message: "Photo captured")
        
        guard let continuation = removeContinuation(for: photo.resolvedSettings.uniqueID) else {
            return
        }

        if let error {
            Logger.log(error: error)
            continuation.resume(throwing: error)
        } else {
            nonisolated(unsafe) let uncheckedPhoto = photo
            continuation.resume(returning: uncheckedPhoto)
        }
    }
}

nonisolated private extension AespaCoreCamera {
    func setContinuation(
        _ continuation: CheckedContinuation<AVCapturePhoto, Error>,
        for uniqueID: Int64
    ) {
        captureLock.lock()
        captureContinuations[uniqueID] = continuation
        captureLock.unlock()
    }
    
    func removeContinuation(for uniqueID: Int64) -> CheckedContinuation<AVCapturePhoto, Error>? {
        captureLock.lock()
        defer { captureLock.unlock() }
        return captureContinuations.removeValue(forKey: uniqueID)
    }
}
