//
//  CharacterService.swift
//
//  Created by Alvin Ling on 5/23/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import CharacterAPI

extension CharacterService {
    static let shared = CharacterService.init(url: Configuration.endpoint)
}
