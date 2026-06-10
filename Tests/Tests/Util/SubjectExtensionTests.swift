//
//  SubjectExtensionTests.swift
//  Aespa-iOS-testTests
//
//  Created by Codex on 2026/06/05.
//

import Combine
import XCTest

@testable import Aespa

final class SubjectExtensionTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func tearDownWithError() throws {
        cancellables.removeAll()
    }

    func testSendOnMainThread_whenCalledFromMainThread_deliversImmediately() {
        let subject = PassthroughSubject<Int, Never>()
        var receivedValue: Int?
        var deliveredOnMainThread = false

        subject
            .sink { value in
                receivedValue = value
                deliveredOnMainThread = Thread.isMainThread
            }
            .store(in: &cancellables)

        subject.sendOnMainThread(1)

        XCTAssertEqual(receivedValue, 1)
        XCTAssertTrue(deliveredOnMainThread)
    }

    func testSendOnMainThread_whenCalledFromBackgroundThread_deliversOnMainThread() {
        let subject = PassthroughSubject<Int, Never>()
        let expectation = expectation(description: "Value delivered on main thread")
        var receivedValue: Int?
        var deliveredOnMainThread = false

        subject
            .sink { value in
                receivedValue = value
                deliveredOnMainThread = Thread.isMainThread
                expectation.fulfill()
            }
            .store(in: &cancellables)

        DispatchQueue.global(qos: .utility).async {
            subject.sendOnMainThread(2)
        }

        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(receivedValue, 2)
        XCTAssertTrue(deliveredOnMainThread)
    }
}
