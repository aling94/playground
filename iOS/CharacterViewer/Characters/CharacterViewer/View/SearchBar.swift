//
//  SearchBar.swift
//  Simpsons
//
//  Created by Alvin Ling on 5/31/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
        
    var body: some View {
        HStack {
            searchField
            if isEditing { cancelButton }
        }
    }
    
    func endEditing() {
        isEditing = false
        text = ""
        UIApplication.shared.dismissKeyboard()
    }
}

private extension SearchBar {
     var searchField: some View {
        TextField("Search ...", text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(fieldOverlay)
            .padding(.horizontal, 10)
            .onTapGesture { self.isEditing = true }
    }
    
    var fieldOverlay: some View {
        HStack {
            // Search Icon
            Image(systemName: .search)
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            // Cancel Button
            if isEditing {
                Button(action: { self.text = "" }) {
                    Image(systemName: .clearSearch)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
    
     var cancelButton: some View {
        Button(action: endEditing) { Text("Cancel") }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
            .animation(.default)
    }
}

private extension String {
    static let search = "magnifyingglass"
    static let clearSearch = "multiply.circle.fill"
}

#if DEBUG

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}

#endif
