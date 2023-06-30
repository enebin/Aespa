//
//  SwiftUI + Extension.swift
//  
//
//  Created by Young Bin on 2023/06/06.
//

import Combine
import SwiftUI
import AVFoundation

public extension AespaSession {
    /// This function is used to create a preview of the session. Doesn't offer any functionalities.
    /// It returns a SwiftUI `View` that displays video as it is being captured.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed.
    func preview(gravity: AVLayerVideoGravity = .resizeAspectFill) -> some View {
        return Preview(of: self, gravity: gravity)
    }
    
    /// This function is used to create an interactive preview of the session.
    /// It returns a SwiftUI `View` that not only displays video as it is being captured,
    /// but also allows user interaction like tap-to-focus, pinch zoom and double tap position change.
    ///
    /// - Parameter gravity: Defines how the video is displayed within the layer bounds.
    ///     .resizeAspectFill` by default, which scales the video to fill the layer bounds.
    ///
    /// - Returns: A SwiftUI `View` that displays the video feed and allows user interaction.
    ///
    /// - Warning: Tap-to-focus works only in `autoFocus` mode.
    ///     Make sure you're using this mode for the feature to work.
    func interactivePreview(
        gravity: AVLayerVideoGravity = .resizeAspectFill,
        option: InteractivePreviewOption = .init()
    ) -> InteractivePreview {
        let internalPreview = Preview(of: self, gravity: gravity)
        return InteractivePreview(internalPreview)
    }
}
