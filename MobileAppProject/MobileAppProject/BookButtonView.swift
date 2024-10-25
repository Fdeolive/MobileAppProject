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
                    //.font(.title)
                    .frame(width: 90, height: 100)
                    .foregroundColor(Color.white)
                    .background(.gray)
                    .font(.system(size: 20, weight: .semibold))
            }else{
                Image(image).resizable().aspectRatio(contentMode: .fit).frame(width: 68, height: 100).background(.gray)
            }
        }
    }
}

#Preview {
    BookButtonView(buttonText: "Word", image: "HP", action:{})
}
