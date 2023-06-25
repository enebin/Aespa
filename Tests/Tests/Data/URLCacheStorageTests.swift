//
//  URLCacheStorageTests.swift
//  TestHostAppTests
//
//  Created by 이영빈 on 2023/06/23.
//

import XCTest
@testable import Aespa

class URLCacheStorageTests: XCTestCase {
    var cacheStorage: URLCacheStorage<String>!
    var testURL: URL!

    override func setUp() {
        super.setUp()
        cacheStorage = URLCacheStorage<String>()
        testURL = URL(string: "file://path/to/file")
    }
    
    override func tearDown() {
        cacheStorage = nil
        testURL = nil
        super.tearDown()
    }
    
    func testStoreAndGet() {
        let expectedValue = "Test String"
        cacheStorage.store(expectedValue, at: testURL)
        
        let storedValue = cacheStorage.get(testURL)
        
        XCTAssertEqual(expectedValue, storedValue)
    }
    
    func testEmpty() {
        let value = "Test String"
        cacheStorage.store(value, at: testURL)
        
        cacheStorage.empty()
        
        let retrievedValue = cacheStorage.get(testURL)
        
        XCTAssertNil(retrievedValue)
    }
    
    func testAll() {
        let value1 = "Test String 1"
        let value2 = "Test String 2"
        
        let url1 = URL(string: "file://path/to/file1")
        let url2 = URL(string: "file://path/to/file2")
        
        cacheStorage.store(value1, at: url1!)
        cacheStorage.store(value2, at: url2!)
        
        let allValues = cacheStorage.all
        let expectedValues = [value1, value2]
        
        XCTAssertEqual(Set(allValues), Set(expectedValues))
    }
}
