//
//  AlbumUtilTests.swift
//  Aespa-iOS-testTests
//
//  Created by Young Bin on 2023/06/17.
//

import XCTest
import Photos
import AVFoundation

import Cuckoo

@testable import Aespa

final class AlbumUtilTests: XCTestCase {
    var mockLibrary: MockAespaAssetLibraryRepresentable!
    var mockAlbum: MockAespaAssetCollectionRepresentable!

    override func setUpWithError() throws {
        mockLibrary = MockAespaAssetLibraryRepresentable()
        mockAlbum = MockAespaAssetCollectionRepresentable()
    }

    override func tearDownWithError() throws {
        mockLibrary = nil
        mockAlbum = nil
    }

    func testAlbumImporter_albumExists() throws {
        let albumName = "test"
        let options = PHFetchOptions()
        let mockAlbum = MockAespaAssetCollectionRepresentable()
        
        // Success case
        stub(mockLibrary) { proxy in
            when(proxy.fetchAlbum(title: albumName,
                                  fetchOptions: equal(to: options))).thenReturn(mockAlbum)
            when(proxy.performChangesAndWait(anyClosure())).thenDoNothing()
        }
        
        let _: MockAespaAssetCollectionRepresentable = try AlbumImporter.getAlbum(name: albumName, in: mockLibrary, options)
        
        verify(mockLibrary)
            .fetchAlbum(title: albumName, fetchOptions: equal(to: options))
            .with(returnType: MockAespaAssetCollectionRepresentable?.self)
        
        verify(mockLibrary, never())
            .performChangesAndWait(anyClosure())
            .with(returnType: Void.self)
    }
    
    func testAlbumImporter_albumNotExists() throws {
        let albumName = "test"
        let options = PHFetchOptions()
        let mockAlbum = MockAespaAssetCollectionRepresentable()
        
        // Success case
        stub(mockLibrary) { proxy in
            when(proxy.fetchAlbum(title: albumName,
                                  fetchOptions: equal(to: options))
                 as ProtocolStubFunction<(String, PHFetchOptions), MockAespaAssetCollectionRepresentable?>
            ).thenReturn(nil)
            
            when(proxy.performChangesAndWait(anyClosure())).thenDoNothing()
        }
        
        let result: MockAespaAssetCollectionRepresentable? = try? AlbumImporter.getAlbum(name: albumName, in: mockLibrary, options)
        XCTAssertNil(result)
        
        verify(mockLibrary, times(2))
            .fetchAlbum(title: albumName, fetchOptions: equal(to: options))
            .with(returnType: MockAespaAssetCollectionRepresentable?.self)
        
        verify(mockLibrary, times(1))
            .performChangesAndWait(anyClosure())
            .with(returnType: Void.self)
    }
}
