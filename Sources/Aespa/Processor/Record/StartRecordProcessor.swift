//
//  RecordingStarter.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import UIKit
import AVFoundation

nonisolated struct StartRecordProcessor: AespaMovieFileOutputProcessing, @unchecked Sendable {
    let filePath: URL
    let delegate: AVCaptureFileOutputRecordingDelegate
    let autoVideoOrientationEnabled: Bool

    func process<T: AespaFileOutputRepresentable>(_ output: T) throws {
        guard let connection = output.getConnection(with: .video) else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        if autoVideoOrientationEnabled {
            connection.orientation(to: DeviceOrientationProvider.currentVideoOrientation)
        }

        output.startRecording(to: filePath, recordingDelegate: delegate)
    }
}
