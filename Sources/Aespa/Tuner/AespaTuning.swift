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
    func tune(_ session: some AespaCoreSessionRepresentable) throws
}

protocol AespaConnectionTuning {
    func tune(_ connection: AVCaptureConnection) throws
}

/// - Warning: Do not `lock` or `release` device yourself. It can cause deadlock.
///     Instead, use `needLock` flag
protocol AespaDeviceTuning {
    var needLock: Bool { get }
    func tune(_ device: AVCaptureDevice) throws
}
