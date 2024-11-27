//
//  ContentView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//


import SwiftUI

struct BookCaseView: View {
    @EnvironmentObject var username: Username
    @EnvironmentObject var shelvesGlobal: ShelvesGlobal
    @State private var addBook = false
    //@State private var myShelf = Shelf("shelf1",[Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""), Book("Fablehaven", "1234", "Like New", 9.00, "FablehavenCover", "")])
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: {print("Add shelf button"); addBook = true}) {
                        Text("Add + / Remove -").padding()
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.width * 0.68,
                                   height: 35, alignment: .leading)
                            .foregroundColor(Color.white)
                            .background(.brown)
                            .cornerRadius(10)
                    }.padding()

                    ForEach(0..<shelvesGlobal.shelves.count, id: \.self){shelf in
                        ShelfView(shelfTitle: shelvesGlobal.shelves[shelf].shelfTitle, books: shelvesGlobal.shelves[shelf].shelfBooks)
                    }


                    
                    /*ShelfView(shelfTitle: myShelf.shelfTitle, books: myShelf.shelfBooks)
                    ShelfView(shelfTitle: "t2", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""), Book("1984", "1234", "Well Loved", 3.00, "", ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", ""), Book("Brave New World", "1234", "Good", 1.00, "", "")])
                    ShelfView(shelfTitle: "t3", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""), Book("1984", "1234", "Well Loved", 3.00, "", ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", ""), Book("Brave New World", "1234", "Good", 1.00, "", "")])
                    ShelfView(shelfTitle: "empty but also really long title", books: [])*/
                }
            }.navigationDestination(isPresented: $addBook) {AddShelfView()}
        }/*.onAppear(){
            DBShelvesConnect(username: username.username).callGetShelves(shelvesGlobal: shelvesGlobal)
            DBShelvesConnect(username: username.username).callFillShelves(shelvesGlobal: shelvesGlobal)
        }*/
    }
}

#Preview {
    BookCaseView()
        .environmentObject(Username())
        .environmentObject(ShelvesGlobal())
}
