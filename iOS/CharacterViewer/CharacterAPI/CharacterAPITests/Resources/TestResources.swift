//
//  TestResources.swift
//  CharacterAPITests
//
//  Created by Alvin Ling on 5/30/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

final class TestResources {
    
    static func resource(name: String, type: FileType) -> Data? {
        guard let path = Bundle(for: Self.self).path(forResource: name, ofType: type.rawValue)
        else { return nil }
        return try? String(contentsOfFile: path).data(using: .utf8)
    }
    
    static var characterData: Data? { resource(name: .characterResponse, type: .json) }
}

// MARK: - Resource File Types
enum FileType: String {
    case json
}

// MARK: - Resource File Names
private extension String {
    static let characterResponse = "MockCharacterResponse"
}
