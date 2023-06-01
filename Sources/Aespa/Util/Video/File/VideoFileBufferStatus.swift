//
//  VideoFileIOStatus.swift
//  
//
//  Created by Young Bin on 2023/05/30.
//

import Foundation

public enum VideoFileBufferStatus {
    case undefined
    case ready
    case recording
    case done(_ videoFile: VideoFile)
    case error(_ error: Error)
}
