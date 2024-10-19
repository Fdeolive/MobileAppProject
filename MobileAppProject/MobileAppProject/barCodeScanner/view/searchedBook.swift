//
//  searchedBook.swift
//  Query
//
//  Created by Fernanda Girelli on 10/16/24.
//

import SwiftUI

struct searchedBook: View {
    @StateObject var viewModel = ebookListViewModel()
    
    
    var body: some View {
        List(viewModel.eBooks) { ebook in Text(ebook.trackName)}
            .searchable(text: $viewModel.searchTerm)
        }
    }


#Preview {
    searchedBook()
}
