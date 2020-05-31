//
//  CharaterAPI.swift
//  CharacterAPI
//
//  Created by Alvin Ling on 5/30/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation
import Combine


public protocol CharacterAPI {
    func fetch() -> AnyPublisher<[TVCharacter], Error>
}

public struct CharacterService: CharacterAPI {
    
    private let session: URLSession
    private let url: URL
    
    public init(session: URLSession = .shared, url: URL) {
        self.session = session
        self.url = url
    }
    
    public func fetch() -> AnyPublisher<[TVCharacter], Error> {
        session.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .flatMap(maxPublishers: .max(1)) { $0.data.characters }
            .eraseToAnyPublisher()
    }
}

private extension Data {
    
    var characters: AnyPublisher<[TVCharacter], Error> {
        Just(self)
            .decode(type: CharacterResponse.self, decoder: JSONDecoder())
            .map { $0.characters }
            .eraseToAnyPublisher()
    }
}
