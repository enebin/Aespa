//
//  AespaCoreCamera+BracketedCapture.swift
//
//
//  Created by Alex Luna on 08/12/2023.
//

import Combine
import Foundation
import AVFoundation

/// Takes a series of bracketed pictures with the specified config
class AespaBracketedCamera: AespaCoreCamera {
    private var bracketedPhotos: [AVCapturePhoto] = []
    private var dispatchGroup = DispatchGroup()
    private var expectedPhotoCount: Int = 0
    private let photoCaptureCompletion = PassthroughSubject<[AVCapturePhoto], Error>()
    private var cancellables = Set<AnyCancellable>()

    func captureBracketed(
        settings: [AVCapturePhotoBracketSettings],
        autoVideoOrientationEnabled: Bool
    ) async throws -> [AVCapturePhoto] {
        self.expectedPhotoCount = settings.count
        self.bracketedPhotos.removeAll()

        let processor = BracketedCapturePhotoProcessor(settingsArray: settings, 
                                                       delegate: self,
                                                       autoVideoOrientationEnabled: autoVideoOrientationEnabled,
                                                       dispatchGroup: dispatchGroup)
        try run(processor: processor)

        // Use a Future to convert the Combine Publisher to an async/await pattern
        let photos: [AVCapturePhoto] = try await withCheckedThrowingContinuation { continuation in
            photoCaptureCompletion
                .first()
                .timeout(10, scheduler: DispatchQueue.global())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log(message: "Capture completed successfully.")
                    case .failure(let error):
                        Logger.log(error: error, message: "Capture failed with error.")
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { capturedPhotos in
                    Logger.log(message: "Received photos: \(capturedPhotos)")
                    continuation.resume(returning: capturedPhotos)
                })
                .store(in: &cancellables)
        }
        return photos
    }
}

extension AespaBracketedCamera {
    override func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            photoCaptureCompletion.send(completion: .failure(error))
        } else {
            bracketedPhotos.append(photo)
            dispatchGroup.leave()
            if bracketedPhotos.count == expectedPhotoCount {
                photoCaptureCompletion.send(bracketedPhotos)
                photoCaptureCompletion.send(completion: .finished)
            }
        }
    }
}
