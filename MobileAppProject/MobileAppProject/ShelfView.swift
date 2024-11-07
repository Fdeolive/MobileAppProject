//
//  ShelfView.swift
//  BookCaseDesign
//
//  Displays a shelf title as a button to access that shelf
//  Displays books on the shelf as a horizontal scroll of buttons that allow more book info
//

import SwiftUI

struct ShelfView: View {
    
    
    //Todo: should it have at state
    var shelfTitle: String = ""
    //var books = ["b1","b2","b3"]
    @State var books = [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")]
    var body: some View {
        
        VStack(spacing: 0){
            //Text(shelfTitle).font(.title)
            ShelfTitleButtonView(buttonText: "\(shelfTitle)", action: {print("title button")})
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<books.count){book in
                        BookButtonView(buttonText: books[book].bookTitle, image: books[book].bookImage, action: {print("but")})
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

#Preview {
    ShelfView(shelfTitle: "title", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")])
}
