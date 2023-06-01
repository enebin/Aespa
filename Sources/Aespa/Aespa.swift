////
////  Aespa.swift
////
////
////  Created by Young Bin on 2023/06/01.
////
//
//import Foundation
//
//public typealias AespaSessionStatus = Result<AespaSession, Error>
//
//public class Aespa {
////    static public let session = AespaSession()
//    static public var isConfigured: Bool { session != nil }
//
//    static public func configure(with option: AespaOption) -> AespaSessionStatus {
//        if let session {
//            LoggingManager.logger.log(message: "Session has already been configured somewhere else")
//            return .success(session)
//        }
//
//        let newSession = AespaSession(option: option)
//        do {
//            try newSession.configure()
//            session = newSession
//            LoggingManager.logger.log(message: "Finished configuring session.")
//            return .success(newSession)
//        } catch let error {
//            return .failure(error)
//        }
//    }
//
//    static public func doctor() async -> AespaSessionStatus {
//        guard let session else {
//            return .failure(AespaError.session(reason: .notConfigured))
//        }
//
//        do {
//            try await session.doctor()
//            return .success(session)
//        } catch let error {
//            return .failure(error)
//        }
//    }
//}
