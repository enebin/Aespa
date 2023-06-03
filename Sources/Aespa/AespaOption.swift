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
    public let asset: Asset
    public let session: Session
    public let log: Log
    
    public init(albumName: String, enableLogging: Bool = true) {
        self.init(
            asset: Asset(albumName: albumName),
            session: Session(),
            log: Log(enableLogging: enableLogging))
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
        var autoVideoOrientation: Bool
        
        init(autoVideoOrientation: Bool = true) {
            self.autoVideoOrientation = autoVideoOrientation
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
