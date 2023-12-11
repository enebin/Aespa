//
//  AespaSession+BracketedPictures.swift
//
//
//  Created by Alex Luna on 11/12/2023.
//

import UIKit
import Combine
import Foundation
import AVFoundation

extension AespaSession {
    public func captureBracketedPhotos(count: Int, autoVideoOrientationEnabled: Bool) async throws -> [AVCapturePhoto] {
        let settings = createBracketSettings(count: count)
        return try await bracketedCamera.captureBracketed(settings: settings, autoVideoOrientationEnabled: autoVideoOrientationEnabled)
    }

    /// This static method is used to calculate the exposure of the pictures in batches of 3
    /// - Parameter count: The amount of pictures that will be taken
    /// - Returns: An array of arrays with exposure bracket values, sorted in ascending order
    func createBracketSettings(count: Int) -> [AVCapturePhotoBracketSettings] {
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
}
