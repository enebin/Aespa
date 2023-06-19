//
//  AVCaptureFileOutput+AespaFileOutputRepresentable.swift
//  
//
//  Created by 이영빈 on 2023/06/16.
//

import Foundation
import AVFoundation

protocol AespaFileOutputRepresentable {
    func stopRecording()
    func startRecording(
        to outputFileURL: URL,
        recordingDelegate delegate: AVCaptureFileOutputRecordingDelegate)
    func getConnection(with mediaType: AVMediaType) -> AespaCaptureConnectionRepresentable?
}

extension AVCaptureFileOutput: AespaFileOutputRepresentable {
    func getConnection(with mediaType: AVMediaType) -> AespaCaptureConnectionRepresentable? {
        return connection(with: mediaType)
    }
}
