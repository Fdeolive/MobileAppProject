//
//  BookButtonView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//
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
                    .font(.title)
                    .frame(width: 60, height: 100)
                    .foregroundColor(Color.white)
                    .background(.gray)
            }else{
                Image(image).resizable().aspectRatio(contentMode: .fit).frame(width: 60, height: 100)
            }
        }
    }
}

#Preview {
    BookButtonView(buttonText: "Word", image: "", action:{})
}
