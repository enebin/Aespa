//
//  RecordingStarter.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Combine
import AVFoundation

struct StartRecordProcessor: AespaFileOutputProcessing {
    let filePath: URL
    let delegate: AVCaptureFileOutputRecordingDelegate
    
    func process(_ output: AVCaptureFileOutput) throws {
        guard
            output.connection(with: .video) != nil
        else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        output.startRecording(to: filePath, recordingDelegate: delegate)
    }
}
