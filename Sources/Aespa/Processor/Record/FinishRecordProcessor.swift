//
//  FinishRecordingProcessor.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

nonisolated struct FinishRecordProcessor: AespaMovieFileOutputProcessing, Sendable {
    func process<T: AespaFileOutputRepresentable>(_ output: T) throws {
        output.stopRecording()
    }
}
