//
//  BookButtonView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//

import SwiftUI

struct BookButtonView: View {
    var buttonText: String = ""
    var action: () -> Void
    var body: some View {
            Button(action: action) {
                Text(buttonText)
                    .font(.title)
                    .frame(width: 60, height: 100)
                    .foregroundColor(Color.white)
                    .background(.gray)
                    //.overlay(RoundedRectangle
                      //  .stroke(Color.black, lineWidth: 2))
                    //.cornerRadius(1)
        }
    }
}

#Preview {
    BookButtonView(buttonText: "Word", action:{})
}
