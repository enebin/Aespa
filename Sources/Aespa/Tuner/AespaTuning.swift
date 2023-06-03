//
//  AespaTuning.swift
//  
//
//  Created by Young Bin on 2023/06/02.
//

import Combine
import Foundation
import AVFoundation

public protocol AespaSessionTuning {
    /// - Warning: Do not `begin` or `commit` session change
    /// It can cause deadlock
    var needTransaction: Bool { get }
    func tune(_ session: AVCaptureSession) throws
}

protocol AespaConnectionTuning {
    /// - Warning: Do not `begin` or `commit` session change
    /// It can cause deadlock
    func tune(_ connection: AVCaptureConnection) throws
}

protocol AespaDeviceInputTuning {
    /// - Warning: Do not `begin` or `commit` session change
    /// It can cause deadlock
    func tune(_ deviceInput: AVCaptureDeviceInput) throws
}
