# Aespa Bracketed Camera - Fork

This project is a fork of the [original Aespa camera project](https://github.com/enebin/Aespa). 

## Introduction

Aespa is a comprehensive Swift package designed to simplify video and photo capturing on iOS devices. With its latest enhancements, it now supports Bracketed Picture Capture, allowing photographers to take a series of photos at different exposure values, perfect for HDR imaging and challenging lighting conditions. The `AespaSession` has been extended to accommodate customized bracketed pictures, streamlining the process of capturing and processing multiple exposure shots. This update also introduces a specialized context, camera, and representable for bracketed photos, along with a dedicated photo processor and file management system for bracketed photo files. Whether you're a beginner or an intermediate developer, Aespa's intuitive interface and robust functionality make it an ideal choice for integrating advanced camera capabilities into your iOS projects.

## Enhancements

- **Bracketed Picture Capture**: The fork introduces the capability to take bracketed pictures, allowing photographers to capture multiple shots at different exposure values. This is particularly useful for high dynamic range (HDR) imaging and situations with challenging lighting conditions.

- **Extended AespaSession**: `AespaSession` has been extended to support the capture of customized bracketed pictures. Users can now easily capture a series of photos with varying exposures in a single session.

- **Dedicated Bracketed Photo Context**: A new context, `AespaBracketedPhotoContext`, has been added to manage the state and lifecycle of bracketed photo sessions, ensuring a seamless integration with the existing architecture.

- **Specialized Bracketed Camera**: The `AespaBracketedCamera` class has been introduced to handle the complexities of bracketed photo capture, including managing exposure settings and processing the captured images.

- **Bracketed Photo Representation**: The `BracketedPicture` struct provides a representable model for a collection of bracketed photos, making it easier to manage and display them within the application.

- **Bracketed Photo Processing**: New photo processors, such as `BracketedCapturePhotoProcessor`, have been implemented to handle the post-capture processing of bracketed photos, ensuring that the images are ready for use immediately after capture.

- **Enhanced File Management**: The `BracketedPhotoFiles` structure has been designed to address the storage and management of bracketed photos, providing a robust solution for handling these files within the app's ecosystem.

## Usage

> **Note**
>
> Aespa offers an extensively detailed and ready-to-use code base for a SwiftUI app that showcases most of the package's features. 
> You can access it [here, the demo app](https://github.com/enebin/Aespa/tree/main/Demo/Aespa-iOS).
> For this fork, the main difference is that we can inistantiate a Bracketed Camera from the same Aespa session and use it to take batches of photos, passing the amount of pictures we need.

### Requirements
- Swift 5.5+
- iOS 14.0+

## Installation 
### Swift Package Manager (SPM)
Follow these steps to install **Aespa** using SPM:

1. From within Xcode 13 or later, choose `File` > `Swift Packages` > `Add Package Dependency`.
2. At the next screen, enter the URL for the **Aespa Bracketed Camera** repository in the search bar then click `Next`.
``` Text
https://github.com/LeTarrask/Aespa.git
```
3. For the `Version rule`, select `Up to Next Minor` and specify the current Aespa version then click `Next`.
4. On the final screen, select the `Aespa` library and then click `Finish`.

## Getting Started

To use this forked version in your project, follow these steps:

```
swift
import Aespa

let aespaOption = AespaOption(albumName: "YOUR_ALBUM_NAME")
let aespaSession = Aespa.session(with: aespaOption)
// Use the enhanced features
```

## Implementation Examples

### Configuration
<!-- INSERT_CODE: COMMON_SETTING -->
```swift
// Common setting
aespaSession
    .common(.focus(mode: .continuousAutoFocus))
    .common(.changeMonitoring(enabled: true))
    .common(.orientation(orientation: .portrait))
    .common(.quality(preset: .high))
    .common(.custom(tuner: WideColorCameraTuner())) { result in
        if case .failure(let error) = result {
            print("Error: ", error)
        }
    }
```
<!-- INSERT_CODE: END -->

### Bracketed Photo Capture

To capture 6 bracketed photos with different exposure values, you can use the captureBracketedPhotos method. Here's how you can set it up:

<!-- INSERT_CODE: BRACKETED_PHOTO_CAPTURE -->

```
// Capture 6 bracketed photos
Task {
    do {
        let bracketedPhotos = try await aespaSession.captureBracketedPhotos(count: 6, autoVideoOrientationEnabled: true)
        // Process your bracketed photos here
    } catch {
        print("Error capturing bracketed photos: \(error)")
    }
}
```

### SwiftUI Integration

Aespa also provides a super-easy way to integrate video capture functionality into SwiftUI applications. AespaSession includes a helper method to create a SwiftUI UIViewRepresentable that provides a preview of the video capture.

### Example usage

```
import Aespa
import SwiftUI

struct VideoContentView: View {
    @StateObject private var viewModel = VideoContentViewModel()

    var body: some View {
        ZStack {
            viewModel.preview
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

class VideoContentViewModel: ObservableObject {
    let aespaSession: AespaSession
    var preview: some View {
        aespaSession.interactivePreview()
    }

    init() {
        let option = AespaOption(albumName: "YOUR_ALBUM_NAME")
        self.aespaSession = Aespa.session(with: option)

        setUp()
    }

    func setUp() {
        aespaSession
            .common(.quality(preset: .high))

        // Other options
        // ...
    }
}
```
<!-- INSERT_CODE: END -->

> **Note**
> 
> In `UIKit`, you can access the preview through the `previewLayer` property of `AespaSession`. 
> For more details, refer to the [AVCaptureVideoPreviewLayer](https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer) in the official Apple documentation.

## Contributing
Contributions to Aespa are warmly welcomed. Please feel free to submit a pull request or create an issue if you find a bug or have a feature request.

## License
Aespa is available under the MIT license. See the LICENSE file for more info.
