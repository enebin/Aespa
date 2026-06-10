//
//  LoggingManager.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

nonisolated class Logger: @unchecked Sendable {
    private static let loggingLock = NSRecursiveLock()
    nonisolated(unsafe) private static var isLoggingEnabled = true

    static var enableLogging: Bool {
        get {
            loggingLock.lock()
            defer { loggingLock.unlock() }
            return isLoggingEnabled
        }
        set {
            loggingLock.lock()
            defer { loggingLock.unlock() }
            isLoggingEnabled = newValue
        }
    }

    static func log(message: String) {
        if enableLogging {
            print("[Aespa] \(message)")
        }
    }

    static func log(
        error: Error,
        message: String = "",
        method: String = #function
    ) {
        if enableLogging {
            let timestamp = Date().description
            print(
                "[⚠️ Aespa Error] \(timestamp) |" +
                " Method: \(method) |" +
                " Error: \(error) |" +
                " Description: \(error.localizedDescription) |" +
                (
                    message.isEmpty ? "" : " Message: \(message)"
                )
            )
        }
    }
}
