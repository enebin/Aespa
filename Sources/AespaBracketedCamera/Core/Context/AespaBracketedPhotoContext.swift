//
//  AespaBracketedPhotoContext.swift
//
//
//  Created by Alex Luna on 08/12/2023.
//

import Combine
import Foundation
import AVFoundation


/// This is a child context that inherits from AespaPhotoContext, with a method to take bracketed pictures
open class AespaBracketedPhotoContext: AespaPhotoContext {
    var bracketCount: Int = 3
    internal let camera: AespaBracketedCamera

    // Initialize with additional bracketed settings
    init(
        coreSession: AespaCoreSession,
        camera: AespaBracketedCamera,
        albumManager: AespaCoreAlbumManager,
        option: AespaOption,
        bracketCount: Int
    ) {
        self.bracketCount = bracketCount
        self.camera = camera
        super.init(coreSession: coreSession, camera: camera, albumManager: albumManager, option: option)
    }
}
