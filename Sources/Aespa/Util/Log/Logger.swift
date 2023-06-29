//
//  LoggingManager.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

class Logger {
    static var enableLogging = true

    static func log(message: String) {
        if enableLogging {
            print("[Aespa] \(message)")
        }
    }

    static func log(
        error: Error,
        method: String = #function
    ) {
        if enableLogging {
            print("[Aespa : error] [\(method)] - \(error) : \(error.localizedDescription)")
        }
    }
}
