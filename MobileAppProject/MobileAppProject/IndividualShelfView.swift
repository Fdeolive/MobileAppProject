//
//  IndividualShelfView.swift
//  MobileAppProject
//
//  Diplays individual shelves and Allows user to add books
//  User can also tap books to get book info
//
//

import SwiftUI

struct IndividualShelfView: View {
    @State private var showBook = false  //used to nav to book info
    @State private var showSearchView = false  //used to go to book search
    var shelfTitle: String = ""
    @State var books = [Book("Harry Potter", "1234", "Like New", 5.00, "HP", [""]), Book("1984", "1234", "Well Loved", 3.00, "", [""]), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", [""]), Book("Brave New World", "1234", "Good", 1.00, "", [""])]
    @State var bookDisplayed = Book("Harry Potter", "1234", "Like New", 5.00, "HP", [""])
    var body: some View {
        VStack(spacing: 0){
            ZStack{ //Puts add book button next to shelf title
                Text(shelfTitle).padding()
                    .font(.title)
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 35, alignment: .leading)
                    .foregroundColor(Color.white)
                    .background(.green)
                    .cornerRadius(10)
                //Button takes user to search to add books
                Button("+",action: {showSearchView = true})
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.green)
                    .frame(width: 25, height: 25)
                    .background(.white)
                    .cornerRadius(25 / 2)
                    .offset(x: UIScreen.main.bounds.width * 0.30)
            }.navigationDestination(isPresented: $showSearchView) { fixingShelfView()}
            ScrollView(){
                VStack(spacing: 5){
                    //If no books displays helpful graphic information
                    if (books.count == 0){
                        Image(systemName: "arrow.turn.right.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 68, height: 100)
                            .foregroundColor(Color.red)
                            .offset(x: UIScreen.main.bounds.width * 0.30)
                        Text("No books on this shelf hit the + button to add books").font(.title)
                    }else{
                        ForEach(0..<books.count){book in
                            HStack(spacing: 20){
                                Spacer()
                                //Evenly shows all books in rows of three
                                if (book % 3 == 0){
                                    ThickBookButtonView(
                                        buttonText: books[book].bookTitle,
                                        image: books[book].bookImage,
                                        action: {
                                            print("but")
                                            bookDisplayed = books[book]
                                            showBook = true
                                        }
                                    )
                                    if (book + 1 < books.count){
                                        ThickBookButtonView(
                                            buttonText: books[book+1].bookTitle,
                                            image: books[book+1].bookImage,
                                            action: {
                                                print("but")
                                                bookDisplayed = books[book + 1]
                                                showBook = true
                                            }
                                        )
                                    }else{
                                        Rectangle()  //filler so last books starts on right side
                                            .frame(width: 90, height: 100)
                                            .foregroundColor(Color.white)
                                    }
                                    if (book + 2 < books.count){
                                        ThickBookButtonView(
                                            buttonText: books[book+2].bookTitle,
                                            image: books[book+2].bookImage,
                                            action: {
                                                print("but")
                                                bookDisplayed = books[book + 2]
                                                showBook = true
                                            }
                                        )
                                    }else{
                                        Rectangle()  //filler so last book starts on right side
                                            .frame(width: 90, height: 100)
                                            .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }.padding()
            }
            Spacer()
        }.navigationDestination(isPresented: $showBook) { IndividualBookView(book: bookDisplayed)}
    }
}

#Preview {
    IndividualShelfView(shelfTitle: "Shelf Title", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP", [""]), Book("1984", "1234", "Well Loved", 3.00, "", [""]), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", [""]), Book("Brave New World", "1234", "Good", 1.00, "", [""]), Book("Fablehaven", "1234", "Like New", 9.00, "FablehavenCover", [""]), Book("Fablehaven", "1234", "Like New", 9.00, "FablehavenCover", [""]),Book("Fablehaven", "1234", "Like New", 9.00, "FablehavenCover", [""])])
}
