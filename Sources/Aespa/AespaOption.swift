//
//  AespaOption.swift
//  
//
//  Created by 이영빈 on 2023/05/26.
//

import Foundation
import AVFoundation

/// Represents a closure that, when called, returns a `String` representing a filename.
public typealias FileNamingRule = () -> String

/// `AespaOption` allows customization of various aspects of the video recording process,
/// such as the video asset configuration, session settings and logging preferences.
public struct AespaOption {
    public let asset: Asset
    public let session: Session
    public let log: Log
    
    /// Creates an `AespaOption` with specified album name and an option to enable logging.
    ///
    /// - Parameters:
    ///   - albumName: The name of the album where recorded videos will be saved.
    ///   - enableLogging: A Boolean value that determines whether logging is enabled.
    public init(albumName: String, enableLogging: Bool = true) {
        self.init(
            asset: Asset(albumName: albumName),
            session: Session(),
            log: Log(loggingEnabled: enableLogging))
    }
    
    /// Creates an `AespaOption` with specified asset, session and log options.
    ///
    /// - Parameters:
    ///   - asset: The `Asset` option for configuring video assets.
    ///   - session: The `Session` option for configuring the video session.
    ///   - log: The `Log` option for configuring logging.
    public init(asset: Asset, session: Session, log: Log) {
        self.asset = asset
        self.session = session
        self.log = log
    }
}

public extension AespaOption {
    /// `Asset` provides options for configuring the video assets, such as the album name, file naming rule, and file extension.
    struct Asset {
        /// The name of the album where recorded videos will be saved.
        let albumName: String
        /// The file extension for the recorded videos.
        let fileNameHandler: FileNamingRule
        /// The rule for naming video files.
        let fileExtension: String
        
        init(
            albumName: String,
            fileExtension: FileExtension = .mp4,
            fileNameHandler: @escaping FileNamingRule = FileNamingRulePreset.Timestamp().rule
        ) {
            self.albumName = albumName
            self.fileExtension = fileExtension.rawValue
            self.fileNameHandler = fileNameHandler
        }
    }
    
    /// `Session` provides options for configuring the video recording session, such as automatic video orientation.
    struct Session {
        /// A Boolean value that determines whether video orientation should be automatic.
        var autoVideoOrientationEnabled: Bool = true
        /// An `AVCaptureDevice.DeviceType` value that determines camera device. If not specified, the device is automatically selected.
        var cameraDevicePreference: AVCaptureDevice.DeviceType?
    }
    
    /// `Log` provides an option for enabling or disabling logging.
    struct Log {
        var loggingEnabled: Bool = true
    }
}

/// `AespaOption` extension related to file naming rules and file extensions.
public extension AespaOption {
    /// `FileNamingRulePreset` provides pre-configured file naming rules.
    enum FileNamingRulePreset {
        struct Timestamp {
            let formatter: DateFormatter
            var rule: FileNamingRule {
                return { formatter.string(from: Date()) }
            }
            
            /// Creates a `Timestamp` file naming rule.
            init() {
                formatter = DateFormatter()
                formatter.dateFormat = "yyyy_MM_dd_HH-mm"
            }
        }
        
        struct Random {
            let rule: FileNamingRule = { UUID().uuidString }
        }
    }
    
    /// `FileExtension` provides supported file extensions.
    enum FileExtension: String {
        case mp4
    }
}
