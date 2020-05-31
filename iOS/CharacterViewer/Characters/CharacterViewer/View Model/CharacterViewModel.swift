//
//  CharacterViewModel.swift
//
//  Created by Alvin Ling on 5/23/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import CharacterAPI
import Foundation
import Combine

final class CharacterViewModel: ObservableObject, Identifiable {
    
    @Published
    private(set) var characters: [TVCharacter] = []
    private var disposables = Set<AnyCancellable>()
    
    let service: CharacterAPI
    
    init(_ service: CharacterAPI = CharacterService.shared) {
        self.service = service
    }
    
    func refresh() {
        service.fetch()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    if case .failure = value { self.characters = [] }
                },
                receiveValue: { [weak self] characters in
                    guard let self = self else { return }
                    self.characters = characters
            })
            .store(in: &disposables)
    }
}
