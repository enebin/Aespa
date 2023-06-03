//
//  AespaProcessing.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import Photos
import Foundation
import AVFoundation

protocol AespaFileOutputProcessing {
    func process(_ output: AVCaptureFileOutput) throws
}

protocol AespaAssetProcessing {
    func process(_ photoLibrary: PHPhotoLibrary, _ assetCollection: PHAssetCollection) async throws
}
