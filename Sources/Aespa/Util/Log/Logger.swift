//
//  LoggingManager.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

nonisolated class Logger: @unchecked Sendable {
    nonisolated(unsafe) static var enableLogging = true

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
