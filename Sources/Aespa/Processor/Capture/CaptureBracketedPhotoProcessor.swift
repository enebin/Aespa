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
    let dispatchGroup: DispatchGroup

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
