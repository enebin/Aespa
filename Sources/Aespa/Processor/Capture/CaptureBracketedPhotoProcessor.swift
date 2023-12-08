//
//  CaptureBracketedPhotoProcessor.swift
//
//
//  Created by Alex Luna on 08/12/2023.
//

import UIKit
import AVFoundation


/// This struct is responsible for taking Bracketed Pictures and processing them
struct BracketedCapturePhotoProcessor: AespaCapturePhotoOutputProcessing {
    let settingsArray: [AVCapturePhotoBracketSettings]
    let delegate: AVCapturePhotoCaptureDelegate
    let autoVideoOrientationEnabled: Bool

    /// To ensure that one batch of bracketed photos completes before starting the next, you can use a dispatch group or a semaphore. Here's a conceptual example using a dispatch group:
    let dispatchGroup = DispatchGroup()


    /// This static method is used to calculate the exposure of the pictures in batches of 3
    /// - Parameter count: The amount of pictures that will be taken
    /// - Returns: An array of arrays with exposure bracket values, sorted in ascending order
    static func createBracketSettings(count: Int) -> [AVCapturePhotoBracketSettings] {
        let makeAutoExposureSettings = AVCaptureAutoExposureBracketedStillImageSettings
            .autoExposureSettings(exposureTargetBias:)

        /// Here we compute the exposure values
        /// - Parameter count: Count is the amount if pictures we want
        /// - Returns: We return an array of floats that go from minus half count to plus half count
        /// With the zero included, sorted in ascending order
        let extraValues = Array(-count/2...count/2).map(Float.init).sorted()

        var exposureSettings: [AVCaptureAutoExposureBracketedStillImageSettings] = extraValues.map(makeAutoExposureSettings)

        var allSettings = [AVCapturePhotoBracketSettings]()

        // Split the count into batches of 3 due to API limitations
        let batches = (count + 2) / 3 // This ensures that we round up if there's a remainder

        for _ in 0..<batches {
            let bracketSettings = AVCapturePhotoBracketSettings(
                rawPixelFormatType: kCVPixelFormatType_14Bayer_RGGB,
                processedFormat: nil,
                bracketedSettings: Array(exposureSettings.prefix(3))
            )
            bracketSettings.isHighResolutionPhotoEnabled = true
            allSettings.append(bracketSettings)

            // Remove the settings that have been used
            exposureSettings.removeFirst(min(3, exposureSettings.count))
        }

        return allSettings
    }


    /// Processes Bracketed Pictures from the app.
    func process<T>(_ output: T) throws where T: AespaPhotoOutputRepresentable {
        guard let connection = output.getConnection(with: .video) else {
            throw AespaError.session(reason: .cannotFindConnection)
        }

        if autoVideoOrientationEnabled {
            connection.orientation(to: UIDevice.current.orientation.toVideoOrientation)
        }

        // Here you would call the method to capture a bracketed photo
        for settings in settingsArray {
            dispatchGroup.enter() // You may need to add logic to wait for one batch to complete before starting the next
            output.capturePhoto(with: settings, delegate: delegate)
            dispatchGroup.wait()
        }
    }
}
