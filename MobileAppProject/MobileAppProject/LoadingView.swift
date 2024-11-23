//
//  LoadingView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/23/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    private let lightGreen = Color(red: 200/255, green: 255/255, blue: 150/255)
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(systemName: "book.circle").font(.system(size: 100)).rotationEffect(Angle(degrees: isLoading ? 360: 0))
                    .animation(Animation.default.repeatForever(autoreverses: false)).foregroundStyle(Color.white).onAppear {
                        isLoading = true
                    }
                Spacer()
                Text("Welcome to Book Hunting!").font(.title2).bold().foregroundStyle(Color.white)
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height).background(Color.green)
        }
    }
}

#Preview {
    LoadingView()
}
