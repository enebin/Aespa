//
//  AespaSession+BracketedPictures.swift
//
//
//  Created by Alex Luna on 11/12/2023.
//

import UIKit
import Combine
import Foundation
import AVFoundation

extension AespaSession {
    public func captureBracketedPhotos(count: Int, autoVideoOrientationEnabled: Bool) async throws -> [AVCapturePhoto] {
        try await bracketedCamera.captureBrackets(autoVideoOrientationEnabled: autoVideoOrientationEnabled)
    }
}
