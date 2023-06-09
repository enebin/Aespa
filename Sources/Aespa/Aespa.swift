//
//  Aespa.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

open class Aespa {
    /// The core `AespaSession` that manages the actual video recording session.
    private static var core: AespaSession?
    
    /// Creates a new `AespaSession` with the given options.
    ///
    /// - Parameters:
    ///   - option: The `AespaOption` to configure the session.
    /// - Returns: The newly created `AespaSession`.
    public static func session(with option: AespaOption) -> AespaSession {
        let newCore = AespaSession(option: option)
        
        core = newCore
        return newCore
    }
    
    /// Configures the `AespaSession` for recording.
    /// Call this method to start the flow of data from the capture session’s inputs to its outputs.
    ///
    /// This method ensures that necessary permissions are granted and the session is properly configured before starting.
    /// If either the session isn't configured or the necessary permissions aren't granted, it throws an error.
    ///
    /// - Warning: This method is synchronous and blocks until the session starts running or it fails,
    ///     which it reports by posting an `AVCaptureSessionRuntimeError` notification.
    public static func configure() async throws {
        guard let core = core else {
            throw AespaError.session(reason: .notConfigured)
        }
        
        guard
            case .permitted = await AuthorizationChecker.checkCaptureAuthorizationStatus()
        else {
            throw AespaError.permission(reason: .denied)
        }
        
        try core.startSession()
        
        Logger.log(message: "Session configured successfully")
    }
}
