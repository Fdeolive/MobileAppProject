//
//  BookButtonView.swift
//  BookCaseDesign
//
//  Book button.  Display the book as an image or if no image available by title.
//  If no image makes the button thicker to acomade short text
//
//  Potential Todo: make bokk adjust to fit all titles
//Todo Integrate BookClass

import SwiftUI

struct BookButtonView: View {
    var buttonText: String = ""
    var image: String = ""
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            if (image.count <= 0){
                Text(buttonText)
                    .frame(width: 90, height: 100)
                    .foregroundColor(Color.white)
                    .background(.gray)
                    .font(.system(size: 20, weight: .semibold))
            }else{
                //Image(image).resizable().aspectRatio(contentMode: .fit).frame(width: 68, height: 100).background(.gray)
                
                AsyncImage(url: URL(string: image)){ image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle().background(.gray)
                }.frame(width: 68, height: 100).background(.gray)
            }
        }
    }
}

#Preview {
    BookButtonView(buttonText: "Word", image: "https://books.google.com/books/content?id=_oaAHiFOZmgC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api", action:{})
}
