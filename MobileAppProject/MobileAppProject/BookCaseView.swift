//
//  ContentView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//

//TODO: make titles cover half of screen rather than be sized

import SwiftUI

struct BookCaseView: View {
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    ShelfView(shelfTitle: "t1", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("Fablehaven", "1234", "Like New", 9.00, "FablehavenCover")])
                    ShelfView(shelfTitle: "t2")
                    ShelfView(shelfTitle: "t3")
                }
            }
        }
    }
}

#Preview {
    BookCaseView()
}
