//
//  CharacterModelTests.swift
//  CharacterAPITests
//
//  Created by Alvin Ling on 5/30/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import XCTest
@testable import CharacterAPI

class CharacterModelTests: XCTestCase {
    
    func getCharacters() -> [TVCharacter]? {
        guard let data = TestResources.characterData else { return nil }
        return try? JSONDecoder().decode(CharacterResponse.self, from: data).characters
    }

    func testDecode() {
        guard let data = getCharacters()
        else {
            XCTFail("Failed to decode response")
            return
        }
        XCTAssertFalse(data.isEmpty)
        XCTAssertEqual(data.count, 3)
    }
    
    func testDecodeName() {
        guard let data = getCharacters(),
            let character = data.first(where: { $0.info.contains("Fat Tony") })
        else {
            XCTFail("Failed to decode response")
            return
        }
        XCTAssertEqual(character.name, "Fat Tony")
    }
}
