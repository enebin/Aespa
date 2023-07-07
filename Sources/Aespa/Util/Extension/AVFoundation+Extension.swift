//
//  AVFoundation + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/28.
//

import AVFoundation

extension AVCaptureDevice.Position {
    var chooseBestCamera: AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera,
                                                                              .builtInTripleCamera,
                                                                              .builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: self)
        
        // Sort the devices by resolution
        let sortedDevices = discoverySession.devices.sorted { (device1, device2) -> Bool in
            guard let maxResolution1 = device1.maxResolution,
                  let maxResolution2 = device2.maxResolution else {
                return false
            }
            return maxResolution1 > maxResolution2
        }

        // Return the device with the highest resolution, or nil if no devices were found
        return sortedDevices.first
    }
}

import UIKit

extension AVCapturePhoto {
    var image: UIImage? {
        guard let imageData = fileDataRepresentation() else { return nil }
        return UIImage(data: imageData)
    }
}
