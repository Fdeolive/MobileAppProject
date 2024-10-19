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
        ScrollView {
            VStack(alignment: .leading) {
                ShelfView(shelfTitle: "t1", books: ["1.1","1.2","1.3", "1.4", "1.5","1.6","1.7"])
                ShelfView(shelfTitle: "t2")
                ShelfView(shelfTitle: "t3")
            }
        }
    }
}

#Preview {
    BookCaseView()
}
