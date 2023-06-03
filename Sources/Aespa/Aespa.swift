//
//  Aespa.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

open class Aespa {
    private static var core: AespaSession?
    
    public static func session(with option: AespaOption) -> AespaSession {
        let newCore = AespaSession(option: option)
        
        core = newCore
        return newCore
    }
    
    /// This method calls `AVCaptureSession`'s `startRunning` method, which is explained:
    /// Call this method to start the flow of data from the capture session’s inputs to its outputs.
    /// This method is synchronous and blocks until the session starts running or it fails,
    /// which it reports by posting an `AVCaptureSessionRuntimeError` notification.
    public static func configure() async throws {
        guard let core else {
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
