//
//  LoggingManager.swift
//  
//
//  Created by Young Bin on 2023/05/27.
//

import Foundation

class LoggingManager {
    static let logger = LoggingManager()
    
    private let showLog = true
    
    func log(message: String) {
        if showLog {
            print("[Aespa] \(message)")
        }
    }
    
    func log(error: Error, file: String = (#file as NSString).lastPathComponent, method: String = #function) {
        if showLog {
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
