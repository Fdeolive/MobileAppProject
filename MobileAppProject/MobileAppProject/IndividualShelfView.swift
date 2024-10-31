//
//  IndividualShelfView.swift
//  MobileAppProject
//
//  Created by user264275 on 10/31/24.
//

import SwiftUI

struct IndividualShelfView: View {
    var shelfTitle: String = ""
    //var books = ["b1","b2","b3"]
    @State var books = [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")]
    var body: some View {
        
        VStack(spacing: 0){
            Text(shelfTitle).padding()
                .font(.title)
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 35, alignment: .leading)
                .foregroundColor(Color.white)
                .background(.green)
                .cornerRadius(10)
            ScrollView(.horizontal){
                /*HStack{
                    ForEach(books, id: \.self){book in
                        BookButtonView(buttonText: "\(book)", action: {print("but")})
                    }
                }.padding()*/
                VStack{
                    ForEach(0..<books.count){book in
                        HStack{
                            if (book % 3 == 0){
                                BookButtonView(buttonText: books[book].bookTitle, image: books[book].bookImage, action: {print("but")})
                                if (book + 1 < books.count){
                                    BookButtonView(buttonText: books[book+1].bookTitle, image: books[book+1].bookImage, action: {print("but")})
                                }
                                if (book + 2 < books.count){
                                    BookButtonView(buttonText: books[book+2].bookTitle, image: books[book+2].bookImage, action: {print("but")})
                                }
                            }
                        }.padding()
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

#Preview {
    IndividualShelfView(shelfTitle: "title", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP"), Book("1984", "1234", "Well Loved", 3.00, ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, ""), Book("Brave New World", "1234", "Good", 1.00, "")])
}
