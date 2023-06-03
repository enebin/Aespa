//
//  FinishRecordingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Combine
import AVFoundation

struct FinishRecordProcessor: AespaFileOutputProcessing {
    func process(_ output: AVCaptureFileOutput) throws {
        output.stopRecording()
    }
}
