// ToggleButtonView
// CS 3750
// A button that fits the wireframe and has two different size options as well as some other customization

import SwiftUI

struct FilterButtonView: View {
    var buttonText: String = ""
    var action: () -> Void
    var foregroundColor = Color(red: 0/255, green: 150/255, blue: 75/255)
    var backgroundColor = Color(red: 230/255, green: 255/255, blue: 220/255)
    var borderColor = Color.white
    var buttonWidth: CGFloat = 150
    var buttonFontLarge = false
    var body: some View {
        if buttonFontLarge == false {
            Button(action: action) {
                Text(buttonText).padding(5).font(.body).frame(width: buttonWidth).foregroundColor(foregroundColor).background(backgroundColor).cornerRadius(5).overlay(RoundedRectangle(cornerRadius: 5).stroke(borderColor, lineWidth: 2))
            }
        } else {
            Button(action: action) {
                Text(buttonText).padding(10).font(.body).frame(width: buttonWidth).foregroundColor(foregroundColor).background(backgroundColor).cornerRadius(5).overlay(RoundedRectangle(cornerRadius: 5).stroke(borderColor, lineWidth: 2))
            }
        }
    }
}
