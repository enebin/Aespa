//
//  CapturePhotoProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/18.
//

import UIKit
import AVFoundation

struct CapturePhotoProcessor: AespaCapturePhotoOutputProcessing {
    let setting: AVCapturePhotoSettings
    let delegate: AVCapturePhotoCaptureDelegate
    let autoVideoOrientationEnabled: Bool

    func process<T>(_ output: T) throws where T: AespaPhotoOutputRepresentable {
        guard let connection = output.getConnection(with: .video) else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        if autoVideoOrientationEnabled {
            connection.orientation(to: UIDevice.current.orientation.toVideoOrientation)
        }

        output.capturePhoto(with: setting, delegate: delegate)
    }
}
