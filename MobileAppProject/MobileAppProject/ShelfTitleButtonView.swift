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
            ZStack{
                Text(buttonText).padding()
                    .font(.title)
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 35, alignment: .leading)
                    .foregroundColor(Color.white)
                    .background(.green)
                    .cornerRadius(10)
                Image(systemName: "arrowshape.right.fill").foregroundColor(Color.white).padding([.leading], (UIScreen.main.bounds.width * 0.6))
            }
        }

        //}
    }
}

#Preview {
    ShelfTitleButtonView(buttonText: "Word", action:{})
}
