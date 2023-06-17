//
//  AespaTuning.swift
//  
//
//  Created by Young Bin on 2023/06/02.
//

import Combine
import Foundation
import AVFoundation

/// - Warning: Do not `begin` or `commit` session change yourself. It can cause deadlock.
///     Instead, use `needTransaction` flag
public protocol AespaSessionTuning {
    var needTransaction: Bool { get }
    func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws
}

public extension AespaSessionTuning {
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
