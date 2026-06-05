//
//  Aespa.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Foundation

/// Top-level class that serves as the main access point for video recording sessions.
nonisolated open class Aespa {
    /// The core `AespaSession` that manages the actual video recording session.
    nonisolated(unsafe) private static var core: AespaSession?
    private static let coreLock = NSRecursiveLock()

    /// Creates a new `AespaSession` with the given options.
    ///
    /// - Parameters:
    ///   - option: The `AespaOption` to configure the session.
    /// - Returns: The newly created `AespaSession`.
    public static func session(
        with option: AespaOption,
        onComplete: @escaping CompletionHandler = { _ in }
    ) -> AespaSession {
        var shouldConfigureSession = false
        let currentCore = withCoreLock {
            if let core {
                return core
            }

            let newCore = AespaSession(option: option)
            core = newCore
            shouldConfigureSession = true
            return newCore
        }

        guard shouldConfigureSession else {
            return currentCore
        }

        // Check logging option
        Logger.enableLogging = option.log.loggingEnabled
        
        // Configure session now
        Task {
            guard
                case .permitted = await AuthorizationChecker.checkCaptureAuthorizationStatus()
            else {
                throw AespaError.permission(reason: .denied)
            }
            
            currentCore.startSession(onComplete)
        }
        
        return currentCore
    }
    
    /// Terminates the current `AespaSession`.
    ///
    /// If a session has been started, it stops the session and releases resources.
    /// After termination, a new session needs to be configured to start recording again.
    public static func terminate(_ onComplete: @escaping CompletionHandler = { _ in }) throws {
        guard let core = withCoreLock({ core }) else {
            return
        }

        core.terminateSession { result in
            Self.withCoreLock {
                self.core = nil
            }
            onComplete(result)
        }
    }
}

nonisolated private extension Aespa {
    static func withCoreLock<T>(_ work: () throws -> T) rethrows -> T {
        coreLock.lock()
        defer { coreLock.unlock() }
        return try work()
    }
}
