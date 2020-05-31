//
//  CharacterListView.swift
//
//  Created by Alvin Ling on 5/24/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import SwiftUI
import CharacterAPI
import SDWebImageSwiftUI

struct CharacterListView: View {
    
    @ObservedObject
    var viewModel = CharacterViewModel()
    
    var body: some View {
        NavigationView { listView }
        .onAppear(perform: viewModel.refresh)
    }
    
    var listView: some View {
        List { ForEach(viewModel.characters) { character in
            NavigationLink(character.name, destination: character.detailView) }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Bundle.main.targetName)
    }
}

private extension TVCharacter {
    
    var detailView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: .contentPadding) {
                Text(name).font(.largeTitle)
                if url != nil {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                }
                Text(info).font(.body)
            }
        }.padding([.leading, .trailing, .bottom], .contentPadding)
    }
}

private extension CGFloat {
    static let contentPadding: CGFloat = 25
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
#endif
