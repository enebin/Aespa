//
//  Subject+Extension.swift
//
//
//  Created by Codex on 2026/06/05.
//

import Combine
import Foundation

extension Subject where Failure == Never {
    nonisolated func sendOnMainThread(_ value: Output) {
        if Thread.isMainThread {
            send(value)
        } else {
            let operation = MainThreadSubjectSend(subject: self, value: value)
            DispatchQueue.main.async {
                operation.send()
            }
        }
    }
}

nonisolated private struct MainThreadSubjectSend<WrappedSubject: Subject>: @unchecked Sendable where WrappedSubject.Failure == Never {
    let subject: WrappedSubject
    let value: WrappedSubject.Output

    func send() {
        subject.send(value)
    }
}
