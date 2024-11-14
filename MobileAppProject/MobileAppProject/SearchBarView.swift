// ToggleButtonView
// CS 3750
// A button that fits the wireframe and has two different size options as well as some other customization

import SwiftUI

struct SearchBarView: View {
    var searchText: String = ""
    var searchingValue: Binding<String>
    var action:() -> Void
    var foregroundColor = Color.black
    var backgroundColor = Color(red: 230/255, green: 255/255, blue: 220/255)
    var borderColor = Color.green
    var buttonWidth: CGFloat = 75
    var buttonFontLarge = false
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    TextField(searchText, text: searchingValue)
                        .padding(10)
                        .background(backgroundColor)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.green, lineWidth: 2)
                        )
                        .padding([.leading, .trailing], 30)
                        .padding([.top, .bottom], 10)
                    Button("", systemImage: "magnifyingglass", action: action).foregroundColor(Color.green).padding([.leading], (UIScreen.main.bounds.width - 90))//310)
                }
            }
        }
    }
}

