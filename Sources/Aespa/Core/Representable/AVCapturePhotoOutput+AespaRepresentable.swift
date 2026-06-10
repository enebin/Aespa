//
//  AVCapturePhotoOutput+AespaRepresentable.swift
//  
//
//  Created by Young Bin on 2023/06/18.
//

import Foundation
import AVFoundation

nonisolated protocol AespaPhotoOutputRepresentable {
    func capturePhoto(with: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate)
    func getConnection(with mediaType: AVMediaType) -> AespaCaptureConnectionRepresentable?
}

nonisolated extension AVCapturePhotoOutput: AespaPhotoOutputRepresentable {
    func getConnection(with mediaType: AVMediaType) -> AespaCaptureConnectionRepresentable? {
        return connection(with: mediaType)
    }
}
