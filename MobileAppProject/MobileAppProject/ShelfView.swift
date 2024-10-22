//
//  ShelfView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//

import SwiftUI

struct ShelfView: View {
    var shelfTitle: String = ""
    var books = ["b1","b2","b3"]
    var body: some View {
        
        VStack(spacing: 0){
            //Text(shelfTitle).font(.title)
            ShelfTitleButtonView(buttonText: "\(shelfTitle)", action: {print("title button")})
            ScrollView(.horizontal){
                HStack{
                    ForEach(books, id: \.self){book in
                        BookButtonView(buttonText: "\(book)", action: {print("but")})
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    ShelfView(shelfTitle: "title", books: ["b1","b2","b3"])
}
