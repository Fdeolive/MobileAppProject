//
//  ContentView.swift
//  Login Feature, Book Hunter Project
//
//  Created by Grace E Kinney on 10/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
        @State private var password = ""
        @State private var wrongEmail = 0
        @State private var wrongPass = 0
    
    var body: some View {
        
        NavigationStack {
            // Login Page UI
            ZStack {
                // Dark green
                Color.green.ignoresSafeArea()
                
                Rectangle().trim(from: 0.0, to: 0.5).frame(width: 1000, height: 1000)
                    .foregroundColor(.white)
                
                // White foreground
                Circle()
                    .frame(width: 700.0, height: 800)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Welcome to \n Book Hunter").font(.largeTitle).bold()
                        .padding().offset(y: -75)
                    
                    HStack {
                        Image(systemName: "envelope").foregroundColor(.black.opacity(0.5))
                        TextField("Email Address", text: $email)}.padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).border(.red,   width: CGFloat(wrongEmail)).offset(y: -25)
                    
                    HStack{
                        Image(systemName: "lock").foregroundColor(.black.opacity(0.5))
                        SecureField("Password", text: $password)
                        Image(systemName: "eye").foregroundColor(.black.opacity(0.5))}.padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).border(.red, width: CGFloat(wrongPass))
                    
                        // Login Button, brings user to HomeView
                        Button("Login"){
                            login()
                        }.foregroundColor(.white).bold().frame(width: 300, height: 50).background(Color.green).cornerRadius(10).offset(y: 25)
                }
                
                /// Register Button
                NavigationLink("Need to create an account?\n Register here!", destination: RegisterView())
                    .offset(y: 225)
                    .foregroundColor(.black)
                    .bold()
            }.navigationBarHidden(true)
        }
    }
    
    // Login User Function
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // unwrapped error
            if let error = error {
                        print(error.localizedDescription)
                    }
        }
    }
    
}

#Preview {
    ContentView()
}
