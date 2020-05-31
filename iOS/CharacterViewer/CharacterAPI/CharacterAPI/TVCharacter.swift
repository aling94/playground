//
//  TVCharacter.swift
//  CharacterAPI
//
//  Created by Alvin Ling on 5/30/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

// MARK: - CharacterResponse

public struct CharacterResponse: Decodable {
    public let characters: [TVCharacter]
    
    private enum CodingKeys: String, CodingKey {
        case characters = "RelatedTopics"
    }
}

// MARK: - TVCharacter
public struct TVCharacter: Codable, Identifiable, Hashable {
    public let name: String
    public let icon: Icon
    public let info: String
    
    public var url: URL? { return URL(string: icon.url) }
    
    public var id: String { return name }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case icon = "Icon"
        case info = "Text"
    }
    
    public static func == (lhs: TVCharacter, rhs: TVCharacter) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

public extension TVCharacter {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        icon = try values.decode(Icon.self, forKey: .icon)
        
        let text = try values.decode(String.self, forKey: .info)
        if let separator = text.range(of: " - ") {
            name = "\(text[..<separator.lowerBound])"
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: #"\s*\(.+\)$"#, with: "", options: .regularExpression)
            
            info = "\(text[separator.upperBound...])"
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            name = text
            info = "Description unavailable."
        }
    }
    
    // MARK: - Icon
    struct Icon: Codable {
        public let width, height: String
        public let url: String
        
        private enum CodingKeys: String, CodingKey {
            case width = "Width"
            case height = "Height"
            case url = "URL"
        }
    }
}
