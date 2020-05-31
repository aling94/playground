//
//  CharacterViewModel.swift
//
//  Created by Alvin Ling on 5/23/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import CharacterAPI
import Foundation
import Combine

final class CharacterViewModel: ObservableObject {
    
    let service: CharacterAPI
    
    @Published var searchText: String = ""
    
    private var dataSource: [TVCharacter] = []
    var characters: [TVCharacter] {
        dataSource.filter { searchText.isEmpty || "\($0.name) \($0.info)".contains(searchText) }
    }
    
    private var disposables = Set<AnyCancellable>()
    
    init(_ service: CharacterAPI = CharacterService.shared) {
        self.service = service
    }
    
    func refresh() {
        service.fetch()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    if case .failure = value { self.dataSource = [] }
                    self.objectWillChange.send()
                },
                receiveValue: { [weak self] characters in
                    guard let self = self else { return }
                    self.dataSource = characters
                    self.objectWillChange.send()
            })
            .store(in: &disposables)
    }
}
