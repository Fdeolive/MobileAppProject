//
//  ContentView.swift
//  Login Feature, Book Hunter Project
//
//  Created by Grace E Kinney on 10/9/24.
//

import SwiftUI

struct ContentView: View {
   @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail = 0
    @State private var wrongPass = 0
    @State private var showLoginScreen = false
    var body: some View {
        NavigationView {
            // Login Page UI
            ZStack {
                // Dark green
                Color.green.ignoresSafeArea()
                //Lighter green for layer
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                
                // White fireground
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
               
                // Content: title, email and password textfields, login button
               // TODO: update styling anf functionality to match wireframe
                VStack {
                    Text("Welcome to Book Hunter").font(.largeTitle).bold()
                        .padding()

                   // Login and Register Text
                    HStack {
                        
                        // TODO: setup functionality so that if user is on login screen, the login text will be blue and underlined, and register text will be grey
                        Text("Login").padding() .foregroundColor(.blue).padding()
                        
                        Text("Register").padding()
                    }
                    
                    TextField("Email Address", text: $email).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).border(.red,   width: CGFloat(wrongEmail));                  SecureField("Password", text: $password).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).border(.red, width: CGFloat(wrongPass))

                  // Login Button
                    Button("Login"){
                        
                    }.foregroundColor(.white).bold().frame(width: 300, height: 50).background(Color.green).cornerRadius(10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
