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
nonisolated class AespaCoreRecorder: NSObject, @unchecked Sendable {
    private let core: AespaCoreSession

    /// Notify the end of recording
    private let fileIOResultSubject = PassthroughSubject<Result<URL, Error>, Never>()

    init(core: AespaCoreSession) {
        self.core = core
    }

    func run<T: AespaMovieFileOutputProcessing>(processor: T, _ onComplete: @escaping CompletionHandler) {
        core.run(processor, onComplete)
    }
}

nonisolated extension AespaCoreRecorder {
    func startRecording(
        in filePath: URL,
        _ autoVideoOrientationEnabled: Bool,
        _ onComplete: @escaping CompletionHandler
    ) {
        run(processor: StartRecordProcessor(
            filePath: filePath,
            delegate: self,
            autoVideoOrientationEnabled: autoVideoOrientationEnabled),
            onComplete)
    }
    
    func stopRecording() async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let resumer = RecordingContinuationResumer(continuation)
            
            resumer.subscription = fileIOResultSubject.sink { _ in
                // Do nothing on completion; we're only interested in values.
            } receiveValue: { result in
                resumer.resume(with: result)
            }
            
            run(processor: FinishRecordProcessor()) { result in
                if case .failure(let error) = result {
                    resumer.resume(with: .failure(error))
                }
            }
        }
    }
}

nonisolated private final class RecordingContinuationResumer: @unchecked Sendable {
    private let lock = NSRecursiveLock()
    private let continuation: CheckedContinuation<URL, Error>
    private var didResume = false
    var subscription: Cancellable?
    
    init(_ continuation: CheckedContinuation<URL, Error>) {
        self.continuation = continuation
    }
    
    func resume(with result: Result<URL, Error>) {
        lock.lock()
        guard didResume == false else {
            lock.unlock()
            return
        }
        
        didResume = true
        let subscription = self.subscription
        self.subscription = nil
        lock.unlock()
        
        subscription?.cancel()
        
        switch result {
        case .success(let url):
            continuation.resume(returning: url)
        case .failure(let error):
            continuation.resume(throwing: error)
        }
    }
}

nonisolated extension AespaCoreRecorder: AVCaptureFileOutputRecordingDelegate {
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
