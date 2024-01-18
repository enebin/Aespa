//
//  BracketedPhotoFiles.swift
//
//
//  Created by Alex Luna on 11/12/2023.
//

import SwiftUI

struct BracketedPicture {
    var photos: [PhotoFile]
}

// TODO: Storage: Decide where to store the bracketed pictures. You can use the same mechanism as PhotoFile to save each image in the array to the device's photo library or file system.
// Temporary Storage: If you're storing the images temporarily, ensure you have a cleanup mechanism in place, similar to how VideoFile handles temporary URLs.

extension BracketedPicture {
    var thumbnailImage: Image {
        return photos[photos.count/2].thumbnailImage
    }
}

extension BracketedPicture: Comparable {
    static func < (lhs: BracketedPicture, rhs: BracketedPicture) -> Bool {
        guard let lhsFirstDate = lhs.photos.first?.creationDate,
              let rhsFirstDate = rhs.photos.first?.creationDate else {
            return false
        }
        return lhsFirstDate < rhsFirstDate
    }
}

//In the below code snippet, we're assuming that the captureBracketedPhotos method returns an array of AVCapturePhoto objects. We then map over this array, converting each AVCapturePhoto to a Data object using its fileDataRepresentation() method. This Data object is then passed to the PhotoFileGenerator.generate method along with the current date to create a PhotoFile.

//import Foundation
//import UIKit
//
//// Assuming `capturedPhotos` is an array of `AVCapturePhoto` objects
//let capturedPhotos: [AVCapturePhoto] = try await aespaSession.captureBracketedPhotos(count: 3, autoVideoOrientationEnabled: true)
//
//// Convert each `AVCapturePhoto` to a `PhotoFile`
//let photoFiles: [PhotoFile] = capturedPhotos.compactMap { capturePhoto in
//    guard let photoData = capturePhoto.fileDataRepresentation() else { return nil }
//    let photoFile = PhotoFileGenerator.generate(data: photoData, date: Date())
//    return photoFile
//}
//
//// Create a `BracketedPicture` from the array of `PhotoFile` objects
//let bracketedPicture = BracketedPicture(photos: photoFiles)
//
//// TODO: Implement storage mechanism here








// In the Aespa project, video and regular photos are represented by VideoFile and PhotoFile structs, respectively. These structs are found in the Data/File directory of the repository. Here's how they are generally handled:

//Video Files:
//
//The VideoFile struct includes a path property, which is a URL? that points to the temporary location of the recorded video file. This suggests that videos are initially stored in a temporary directory.
//The creationDate property indicates when the video file was created.
//The thumbnail property is a UIImage that represents a thumbnail image generated from the video content.
//Photo Files:
//
//Although the PhotoFile struct is not detailed in the provided context, it likely follows a similar pattern to VideoFile, with properties for the file path, metadata, and possibly a thumbnail image.
//Storage:
//
//Both video and photo files are likely to be stored temporarily at first, as indicated by the warning in the VideoFile struct that the path is temporary and will be removed once the application terminates.
//For permanent storage, the application would need to implement functionality to save these files to a persistent storage location, such as the device's photo library, a documents directory, or a remote server.
//Management:
//
//The application's codebase likely includes functionality to manage these files, such as saving, deleting, or retrieving them. This could be part of the AespaSession class or other services/classes dedicated to file management.
