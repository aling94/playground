//
//  CharacterAPITests.swift
//  CharacterAPITests
//
//  Created by Alvin Ling on 5/30/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import XCTest
import Combine
@testable import CharacterAPI

class CharacterAPITests: XCTestCase {
    
    var service: CharacterService!
    var disposables: Set<AnyCancellable>!
    
    override func setUp() {
        disposables = Set<AnyCancellable>()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        service = CharacterService(session: session, url: URL(string: "https://test.com")!)
    }

    func testFetch() {
        guard let data = TestResources.characterData else {
            XCTFail("Failed to retrieve response data")
            return
        }
        MockURLProtocol.requestHandler = { request in (HTTPURLResponse(), data) }
        let expect = XCTestExpectation(description: "response")
        service.fetch()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { _ in },
            receiveValue: { characters in
                XCTAssertFalse(characters.isEmpty)
                expect.fulfill()
        })
        .store(in: &disposables)
        
        wait(for: [expect], timeout: 2)
    }
}
