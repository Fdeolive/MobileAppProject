//
//  ShelfView.swift
//  BookCaseDesign
//
//  Displays a shelf title as a button to access that shelf
//  Displays books on the shelf as a horizontal scroll of buttons that allow more book info
//

import SwiftUI

struct ShelfView: View {
    @State private var showShelf = false
    @State private var showBook = false
    @State var bookDisplayed = Book("Harry Potter", "1234", "Like New", 5.00, "HP")
    
    //Todo: should it have at state
    var shelfTitle: String = ""
    @State var books = [Book]()//[Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")]
    
    var body: some View {

        VStack(spacing: 0){
            ShelfTitleButtonView(buttonText: "\(shelfTitle)", action: {print("title button"); showShelf = true})
            ScrollView(.horizontal){
                HStack{
                    if (books.count == 0){
                        Text("No books in shelf yet (tap title then tap + to add books)")
                            .frame(width: 190, height: 100)
                            .foregroundColor(Color.white)
                            .background(.gray)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    ForEach(0..<books.count){book in
                        BookButtonView(
                            buttonText: books[book].bookTitle,
                            image: books[book].bookImage,
                            action: {
                                print("but")
                                showBook = true
                                bookDisplayed = books[book]
                            }
                        )
                    }
                }.padding()
            }.navigationDestination(isPresented: $showShelf) { IndividualShelfView(shelfTitle: shelfTitle, books: books) }
            Spacer()
        }.navigationDestination(isPresented: $showBook) { IndividualBookView(book: bookDisplayed)}
    }
}

#Preview {
    ShelfView(shelfTitle: "title", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")])
}
