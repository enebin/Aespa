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
    private var expectedPhotoCount: Int = 0
    private let photoCaptureCompletion = PassthroughSubject<[AVCapturePhoto], Error>()

    func captureBracketed(
        settings: [AVCapturePhotoBracketSettings],
        autoVideoOrientationEnabled: Bool
    ) async throws -> [AVCapturePhoto] {
        self.expectedPhotoCount = settings.count
        self.bracketedPhotos.removeAll()

        let processor = BracketedCapturePhotoProcessor(settingsArray: settings, delegate: self, autoVideoOrientationEnabled: autoVideoOrientationEnabled)
        try run(processor: processor)

        return try await photoCaptureCompletion
            .first()
            .timeout(10, scheduler: DispatchQueue.global()) // Timeout for the capture process
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Handle successful completion
                    Logger.log(message: "Capture completed successfully.")
                case .failure(let error):
                    // Handle failure
                    Logger.log(error: error, message: "Capture failed with error.")
                }
            }, receiveValue: { capturedPhotos in
                // Handle received photos
                Logger.log(message: "Received photos: \(capturedPhotos)")
                // You can process the captured photos here
            })
    }
}

extension AespaBracketedCamera {
    override func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            photoCaptureCompletion.send(completion: .failure(error))
        } else {
            bracketedPhotos.append(photo)
            if bracketedPhotos.count == expectedPhotoCount {
                photoCaptureCompletion.send(bracketedPhotos)
                photoCaptureCompletion.send(completion: .finished)
            }
        }
    }
}
