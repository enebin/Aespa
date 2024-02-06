//
//  AssetProcessorTests.swift
//  Aespa-iOS-testTests
//
//  Created by 이영빈 on 2023/06/16.
//

import XCTest
import Photos
import AVFoundation

import Cuckoo

@testable import Aespa

final class AssetProcessorTests: XCTestCase {
    var library: MockAespaAssetLibraryRepresentable!
    var collection: MockAespaAssetCollectionRepresentable!

    override func setUpWithError() throws {
        library = MockAespaAssetLibraryRepresentable()
        collection = MockAespaAssetCollectionRepresentable()
    }

    override func tearDownWithError() throws {
        library = nil
        collection = nil
    }

    func testVideoAddition() async throws {
        let url = URL(string: "/here/there.mp4")!
        let accessLevel = PHAccessLevel.addOnly
        let processor = VideoAssetAdditionProcessor(filePath: url)
        
        stub(library) { proxy in
            when(proxy.performChanges(anyClosure())).thenDoNothing()
            when(proxy.requestAuthorization(for: equal(to: accessLevel))).thenReturn(.authorized)
        }
        
        stub(collection) { proxy in
            when(proxy.canAdd(video: any())).thenReturn(true)
        }
        
        try await processor.process(library, collection)
        
        verify(library)
            .performChanges(anyClosure())
            .with(returnType: Void.self)
    }

    func testPhotoAddition() async throws {
        let imageData = try XCTUnwrap(UIImage(systemName: "person")?.pngData())
        let accessLevel = PHAccessLevel.addOnly
        let processor = PhotoAssetAdditionProcessor(imageData: imageData)
        
        stub(library) { proxy in
            when(proxy.performChanges(anyClosure())).thenDoNothing()
            when(proxy.requestAuthorization(for: equal(to: accessLevel))).thenReturn(.authorized)
        }
        
        try await processor.process(library, collection)
        
        verify(library)
            .performChanges(anyClosure())
            .with(returnType: Void.self)
    }
}
