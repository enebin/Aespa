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

    private let fileIOResultSubject = PassthroughSubject<Result<AVCapturePhoto, Error>, Never>()
    private var fileIOResultSubsciption: Cancellable?

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
        try run(processor: processor)

        return try await withCheckedThrowingContinuation { continuation in
            fileIOResultSubsciption = fileIOResultSubject
                .subscribe(on: DispatchQueue.global())
                .sink(receiveValue: { result in
                    switch result {
                    case .success(let photo):
                        nonisolated(unsafe) let uncheckedPhoto = photo
                        continuation.resume(returning: uncheckedPhoto)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                })
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

        if let error {
            fileIOResultSubject.send(.failure(error))
            Logger.log(error: error)
        } else {
            fileIOResultSubject.send(.success(photo))
        }
    }
}
