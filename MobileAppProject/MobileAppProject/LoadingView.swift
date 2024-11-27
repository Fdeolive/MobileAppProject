// A loading view for the app
// LoadingView.swift
// MobileAppProject
// Carson J. King

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    private let lightGreen = Color(red: 255/255, green: 250/255, blue: 234/255)
    private let darkGreen = Color(red: 80/255, green: 160/255, blue: 89/255)

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(.quest)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .rotationEffect(Angle(degrees: isLoading ? 360: 0))
                    .animation(Animation.default.repeatForever(autoreverses: false))
                    .foregroundStyle(Color.white)
                    .onAppear {
                        isLoading = true
                    }
                Spacer()
                Text("Welcome to Book Quest!")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(darkGreen)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(lightGreen)
        }
    }
}

#Preview {
    LoadingView()
}
