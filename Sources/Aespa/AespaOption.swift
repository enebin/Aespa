//
//  AespaOption.swift
//  
//
//  Created by 이영빈 on 2023/05/26.
//

import Foundation
import AVFoundation

public typealias FileNamingRule = () -> String

public struct AespaOption {
    static let undefined = AespaOption()
    
    public let asset: Asset
    public let session: Session
    public let log: Log
    
    init() {
        self.init(albumName: "Aespa-default", orientation: .portrait)
    }
    
    public init(albumName: String, orientation: AVCaptureVideoOrientation) {
        self.init(
            asset: Asset(albumName: albumName),
            session: Session(orientation: orientation),
            log: Log())
    }
    
    public init(asset: Asset, session: Session, log: Log) {
        self.asset = asset
        self.session = session
        self.log = log
    }
}

/// Related to file naming rule closure
public extension AespaOption {
    /// Asset related options
    struct Asset {
        let albumName: String
        let fileNameHandler: FileNamingRule
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
    
    struct Session {
        var orientation: AVCaptureVideoOrientation
        var stablizationMode: AVCaptureVideoStabilizationMode
        var videoQuality: AVCaptureSession.Preset
        var cameraPosition: AVCaptureDevice.Position
        var silentMode: Bool
        
        init(
            orientation: AVCaptureVideoOrientation,
            stablizationMode: AVCaptureVideoStabilizationMode = .auto,
            videoQuality: AVCaptureSession.Preset = .high,
            cameraPosition: AVCaptureDevice.Position = .back,
            silentMode: Bool = false
        ) {
            self.orientation = orientation
            self.stablizationMode = stablizationMode
            self.videoQuality = videoQuality
            self.cameraPosition = cameraPosition
            self.silentMode = silentMode
        }
    }
    
    struct Log {
        var enableLogging: Bool = true
    }
}

/// Related to file extension
public extension AespaOption {
    enum FileNamingRulePreset {
        struct Timestamp {
            let formatter: DateFormatter
            var rule: FileNamingRule {
                return { formatter.string(from: Date()) }
            }
            
            init() {
                formatter = DateFormatter()
                formatter.dateFormat = "yyyy_MM_dd_HH-mm"
            }
        }
        
        struct Random {
            let rule: FileNamingRule = { UUID().uuidString }
        }
    }
    
    enum FileExtension: String {
        case mp4
    }
}
