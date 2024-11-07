//
//  ThickBookButtonView.swift
//  MobileAppProject
//
//  Creates a button for books (see BookButtonView)
//  Is used to make all books same size whereas BookButtonView only make title only
//  no image books wider

import SwiftUI

struct ThickBookButtonView: View {
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
                Image(image).resizable().aspectRatio(contentMode: .fit).frame(width: 90, height: 100).background(.gray)
            }
        }
    }
}

#Preview {
    ThickBookButtonView(buttonText: "Word", image: "HP", action:{})
}
