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
    
    static func log(error: Error, file: String = (#file as NSString).lastPathComponent, method: String = #function) {
        if enableLogging {
            print("[Aespa : error] [\(file) : \(method)] - \(error) : \(error.localizedDescription)")
        }
    }
    
    enum Level {
        case debug
        case info
        case warning
        case error
    }
}
