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

    func testAddition() async throws {
        let url = URL(string: "/here/there.mp4")!
        let accessLevel = PHAccessLevel.addOnly
        let processor = AssetAdditionProcessor(filePath: url)
        
        stub(library) { proxy in
            when(proxy.performChanges(anyClosure())).thenDoNothing()
            when(proxy.requestAuthorization(for: equal(to: accessLevel))).thenReturn(.authorized)
        }
        
        stub(collection) { proxy in
            when(proxy.canAdd(any())).thenReturn(true)
        }
        
        try await processor.process(library, collection)
        
        verify(library)
            .performChanges(anyClosure())
            .with(returnType: Void.self)
        
        verify(library)
            .requestAuthorization(for: equal(to: accessLevel))
            .with(returnType: PHAuthorizationStatus.self)
    }
}
