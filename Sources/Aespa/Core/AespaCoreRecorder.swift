//
//  AespaCoreRecorder.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Combine
import Foundation
import AVFoundation

/// Start, stop recording and responsible for notifying the result of recording
class AespaCoreRecorder: NSObject {
    private let core: AespaCoreSession
    
    /// Notify the end of recording
    private let fileIOResultSubject = PassthroughSubject<Result<URL, Error>, Never>()
    
    init(core: AespaCoreSession) {
        self.core = core
    }
    
    func run<T: AespaFileOutputProcessing>(processor: T) throws {
        guard let output = core.movieFileOutput else {
            throw AespaError.session(reason: .cannotFindConnection)
        }
        
        try processor.process(output)
    }
}

extension AespaCoreRecorder {
    var fileIOResultPublihser: AnyPublisher<Result<URL, Error>, Never> {
        return self.fileIOResultSubject.eraseToAnyPublisher()
    }
    
    func startRecording(in filePath: URL) throws {
        try run(processor: StartRecordProcessor(filePath: filePath, delegate: self))
    }
    
    func stopRecording() throws {
        try run(processor: FinishRecordProcessor())
    }
}

extension AespaCoreRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        Logger.log(message: "Recording started")
    }

    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        Logger.log(message: "Recording stopped")

        if let error {
            Logger.log(error: error)
            fileIOResultSubject.send(.failure(error))
        } else {
            fileIOResultSubject.send(.success(outputFileURL))
        }
    }
}
