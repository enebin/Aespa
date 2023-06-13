//
//  AVFoundation + Extension.swift
//  
//
//  Created by Young Bin on 2023/05/28.
//

import AVFoundation

extension AVCaptureConnection {
    func setOrientation(to orientation: AVCaptureVideoOrientation) {
        self.videoOrientation = orientation
    }
    
    func setStabilizationMode(to mode: AVCaptureVideoStabilizationMode) {
        self.preferredVideoStabilizationMode = mode
    }
}

extension AVCaptureDevice.Position {
    var chooseBestCamera: AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTripleCamera],
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

fileprivate extension AVCaptureDevice {
    var maxResolution: Double? {
        var maxResolution: Double = 0
        for format in self.formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let resolution = Double(dimensions.width * dimensions.height)
            maxResolution = max(resolution, maxResolution)
        }
        return maxResolution
    }
}


extension AVCaptureDevice {
    func setZoomFactor(factor: CGFloat) {
        let device = self

        do {
            try device.lockForConfiguration()

            device.videoZoomFactor = factor

            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
    }
}
