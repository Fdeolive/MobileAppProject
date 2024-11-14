//
//  ContentView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//


import SwiftUI

struct BookCaseView: View {
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: {print("Add shelf button")}) {
                        Text("Add Shelf +").padding()
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.width * 0.44,
                                   height: 35, alignment: .leading)
                            .foregroundColor(Color.white)
                            .background(.brown)
                            .cornerRadius(10)
                    }.padding()

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
