//
//  ShelfTitleButtonView.swift
//  BookCaseDesign
//
//  Created by user264275 on 10/17/24.
//

import SwiftUI

struct ShelfTitleButtonView: View {
    var buttonText: String = ""
    //var bounds = UIScreen.main.bounds.width
    var action: () -> Void
    

    var body: some View {
        //GeometryReader { metrics in
        
            Button(action: action) {
                Text(buttonText).padding()
                    .font(.title)
                    .frame(width: /*metrics.size.width * 0.90*/225, height: 35, alignment: .leading)
                    .foregroundColor(Color.white)
                    .background(.green)
                //.overlay(RoundedRectangle
                 // .stroke(Color.black, lineWidth: 2))
                .cornerRadius(10)
           //}
        }
    }
}

#Preview {
    ShelfTitleButtonView(buttonText: "Word", action:{})
}
