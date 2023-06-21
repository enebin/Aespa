//
//  AespaTuning.swift
//  
//
//  Created by Young Bin on 2023/06/02.
//

import Combine
import Foundation
import AVFoundation

/// `AespaSessionTuning` defines a set of requirements for classes or structs that aim to adjust settings
/// for an `AespaCoreSessionRepresentable`.
///
/// - Warning: Do not `begin` or `commit` session change yourself. It can cause deadlock.
///     Instead, use `needTransaction` flag
public protocol AespaSessionTuning {
    /// Determines if a transaction is required for this particular tuning operation.
    /// Default is `true`, indicating a transaction is generally needed.
    var needTransaction: Bool { get }
    
    /// Applies the specific tuning implementation to a given `AespaCoreSessionRepresentable` session.
    /// It is expected that each concrete implementation of `AespaSessionTuning` will provide its own
    /// tuning adjustments here.
    ///
    /// - Parameter session: The `AespaCoreSessionRepresentable` session to be adjusted.
    ///
    /// - Throws: An error if any problems occur during the tuning process.
    func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws
}

/// Default implementation for `AespaSessionTuning`.
public extension AespaSessionTuning {
    /// By default, tuning operations need a transaction. This can be overridden by specific tuners
    /// if a transaction isn't necessary for their operation.
    var needTransaction: Bool { true }
}

/// AespaConnectionTuning
protocol AespaConnectionTuning {
    func tune<T: AespaCaptureConnectionRepresentable>(_ connection: T) throws
}

/// - Warning: Do not `lock` or `release` device yourself. It can cause deadlock.
///     Instead, use `needLock` flag
protocol AespaDeviceTuning {
    var needLock: Bool { get }
    func tune<T: AespaCaptureDeviceRepresentable>(_ device: T) throws
}

extension AespaDeviceTuning {
    var needLock: Bool { true }
}
