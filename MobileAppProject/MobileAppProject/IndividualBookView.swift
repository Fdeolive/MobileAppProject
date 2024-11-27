//
//  IndividualBookView.swift
//  MobileAppProject
//
//  Work in progress
//  Display information about an indivual book

import SwiftUI

struct IndividualBookView: View {
    @State var book = Book("Harry Potter", "1234", "Like New", 5.00, "HP", "")
    var body: some View {
        VStack{
            Text("\(book.bookTitle)").font(.system(size: 30, weight: .semibold))
            if (book.bookImage.count > 0){
                Image(book.bookImage).resizable().aspectRatio(contentMode: .fit).frame(width: 136, height: 200).background(.gray)
            }else{
                Text("No Image Available")
                    .frame(width: 136, height: 200)
                    .background(.gray)
                    .foregroundColor(Color.white)
                    .font(.system(size: 20, weight: .semibold))
                    
            }
            Text("Author: Filler").font(.system(size: 20, weight: .semibold))
            Text("Rating: Filler").font(.system(size: 20, weight: .semibold))
            Text("Summary: Filler\n  Filler...\n  Filler...\n").font(.system(size: 20, weight: .semibold))
            
            Text("Versions:")
                ScrollView(.horizontal){
                    HStack(spacing: 20){
                        Rectangle()
                            .fill(.white)
                            .frame(width: 10, height: 100)
                        ForEach(0..<3){i in
                            Rectangle()
                                .fill(.red)
                                .frame(width: 68, height: 100)
                        }
                    }.padding()
                }
            }
            Spacer()
        }
    
}

#Preview {
    IndividualBookView(book: Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""))
}
