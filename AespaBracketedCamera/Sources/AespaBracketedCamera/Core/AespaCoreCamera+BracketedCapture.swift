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
    private var expectedPhotoCount: Int = 3
    private let photoCaptureCompletion = PassthroughSubject<[AVCapturePhoto], Error>()
    private var cancellables = Set<AnyCancellable>()

    func captureBrackets(
        count: Int,
        autoVideoOrientationEnabled: Bool
    ) async throws -> [AVCapturePhoto] {
        let settings = makeExposureBracketSettings()
        self.bracketedPhotos.removeAll()

        expectedPhotoCount = count

        let processor = BracketedCapturePhotoProcessor(settingsArray: settings, 
                                                       delegate: self,
                                                       autoVideoOrientationEnabled: autoVideoOrientationEnabled)
        try run(processor: processor)

        // Use a Future to convert the Combine Publisher to an async/await pattern
        _ = try await withCheckedThrowingContinuation { continuation in
            photoCaptureCompletion
                .first()
                .timeout(10, scheduler: DispatchQueue.global())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log(message: "Capture completed successfully.")
                        // Resume continuation with the captured photos
                        continuation.resume(returning: self.bracketedPhotos)
                    case .failure(let error):
                        Logger.log(error: error, message: "Capture failed with error.")
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { capturedPhotos in
                    Logger.log(message: "Received photos: \(capturedPhotos)")
                })
                .store(in: &cancellables)
        }
        return bracketedPhotos
    }

    /// This method is used to calculate the exposure of the pictures in batches of 3
    /// - Parameter count: The amount of pictures that will be taken
    /// - Returns: An array of arrays with exposure bracket values, sorted in ascending order
    private func makeExposureBracketSettings() -> [AVCapturePhotoBracketSettings] {
        let makeAutoExposureSettings = AVCaptureAutoExposureBracketedStillImageSettings
            .autoExposureSettings(exposureTargetBias:)

        let count = expectedPhotoCount

        /// Here we compute the exposure values
        /// - Parameter count: Count is the amount if pictures we want
        /// - Returns: We return an array of floats that go from minus half count to plus half count
        /// With the zero included, sorted in ascending order
        let extraValues = Array(-count/2...count/2).map(Float.init).sorted()

        var exposureSettings: [AVCaptureAutoExposureBracketedStillImageSettings] = extraValues.map(makeAutoExposureSettings)

        var allSettings = [AVCapturePhotoBracketSettings]()

        // Split the count into batches of 3 due to API limitations
        let batches = (count + 2) / 3 // This ensures that we round up if there's a remainder

        guard let output = core.photoOutput else {
            fatalError("No available camera output.")
        }
        
        // Checks if we can take ProRaw or Raw
        let query = output.isAppleProRAWEnabled ? { AVCapturePhotoOutput.isAppleProRAWPixelFormat($0) } :
        { AVCapturePhotoOutput.isBayerRAWPixelFormat($0) }

        // 0 means phone cannot take raw pictures
        let rawFormatType = output.availableRawPhotoPixelFormatTypes.first(where: query) ?? 0

        let processedFormat = [AVVideoCodecKey: AVVideoCodecType.hevc]

        for _ in 0..<batches {
            let bracketSettings = AVCapturePhotoBracketSettings(
                rawPixelFormatType: rawFormatType,
                processedFormat: processedFormat,
                bracketedSettings: Array(exposureSettings.prefix(3))
            )
            allSettings.append(bracketSettings)

            // Remove the settings that have been used
            exposureSettings.removeFirst(min(3, exposureSettings.count))
        }

        return allSettings
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
