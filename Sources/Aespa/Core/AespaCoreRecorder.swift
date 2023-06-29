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
    private var fileIOResultSubsciption: Cancellable?

    init(core: AespaCoreSession) {
        self.core = core
    }

    func run<T: AespaMovieFileOutputProcessing>(processor: T, _ errorHandler: @escaping ErrorHandler) {
        guard let output = core.movieFileOutput else {
            errorHandler(AespaError.session(reason: .cannotFindConnection))
            return
        }

        do {
            try processor.process(output)
        } catch {
            errorHandler(error)
        }
    }
}

extension AespaCoreRecorder {
    func startRecording(in filePath: URL, _ errorHandler: @escaping ErrorHandler) {
        run(processor: StartRecordProcessor(filePath: filePath, delegate: self), errorHandler)
    }
    
    func stopRecording() async throws -> URL {
        run(processor: FinishRecordProcessor(), { _ in })
        
        return try await withCheckedThrowingContinuation { continuation in
            fileIOResultSubsciption = fileIOResultSubject.sink { _ in
                // Do nothing on completion; we're only interested in values.
            } receiveValue: { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension AespaCoreRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didStartRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]
    ) {
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
