//
//  ContentView.swift
//  Login Feature, Book Hunter Project
//
//  Created by Grace E Kinney on 10/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import LocalAuthentication
import SwiftKeychainWrapper
import CryptoKit
import FirebaseFirestore

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0  
    @State private var wrongPass = 0

    // State for logging in using biometrics
    @State private var isUnlocked = false
    
    // States for optional checkboxes
    @State private var rememberPassword = false
    @State private var enableFaceID = false
    
    // State for navigation to the next screen after login
    @State private var isLoggedIn = false
    
    // Alert state
    @State private var alertMessage: AlertMessage? = nil
    
    // Password visibility
    @State private var isPasswordVisible = false
    
    // Connection to Firebase
    let db = Firestore.firestore()
    
    // Main Color
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)

    var body: some View {
        NavigationStack {
            ZStack {
                Color(darkGreen).ignoresSafeArea()
                Rectangle().trim(from: 0.0, to: 0.5).frame(width: 1000, height: 1000)
                    .foregroundColor(.white)

                Circle()
                    .frame(width: 700.0, height: 800)
                    .foregroundColor(.white)
                
                VStack {
                    if isUnlocked {
                        Text("Unlocked").offset(y: -125)
                    } else {
                        Text("Locked").offset(y: -125)
                    }
                    
                    Text("Welcome to \n Book Hunter")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .offset(y: -100)
                    
                    HStack {
                        NavigationLink("Login", destination: ContentView())
                            .foregroundColor(.blue)
                        
                        Spacer()
                            .frame(width: 75)
                        
                        NavigationLink("Register", destination: RegisterView())
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 50).offset(y: -60)
                    
                    // Username Field (instead of email)
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.black.opacity(0.5))
                        TextField("Username", text: $username)
                    }.autocapitalization(.none)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongUsername))
                    .offset(y: -75)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.black.opacity(0.5))
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .padding()
                        } else {
                            SecureField("Password", text: $password)
                                .padding()
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongPass))
                    .offset(y: -65)
                    
                    // Remember Password checkbox
                    Toggle("Remember Me", isOn: $rememberPassword)
                        .padding().frame(width: 300).offset(y: -45)
                    
                    // Enable FaceID checkbox
                    Toggle("Enable FaceID", isOn: $enableFaceID)
                        .padding().frame(width: 300).offset(y: -45)
                    
                    // Login Button
                    Button("Login") {
                        login()
                    }
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .offset(y: -25)
                    
                    // Navigation after successful login
                    NavigationLink("", destination: RootView())
                                            .opacity(0)
                                        // Navigate to HomeView after successful login
                                        .navigationDestination(isPresented: $isLoggedIn) {
                                            RootView()
                                        }

                }
                .navigationBarHidden(true).onAppear {
                    retrieveCredentialsFromKeychain()
                }
            }
            .alert(item: $alertMessage) { message in
                Alert(title: Text("Error"), message: Text(message.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Login User Function
    func login() {
        // Validate username and password before proceeding
        if username.isEmpty {
            wrongUsername = 1
            return
        } else {
            wrongUsername = 0
        }
        
        if password.isEmpty {
            wrongPass = 1
            return
        } else {
            wrongPass = 0
        }

        // Check if "Remember Password" checkbox is enabled
        if rememberPassword {
            saveCredentialsToKeychain(username: username, password: password)
        } else {
            clearCredentialsFromKeychain()
        }

        if enableFaceID {
            authenticateWithFaceID()
        } else {
            signInWithUsernamePassword()
        }
    }

    func saveCredentialsToKeychain(username: String, password: String) {
        KeychainWrapper.standard.set(username, forKey: "userUsername")
        KeychainWrapper.standard.set(password, forKey: "userPassword")
    }

    func clearCredentialsFromKeychain() {
        KeychainWrapper.standard.removeObject(forKey: "userUsername")
        KeychainWrapper.standard.removeObject(forKey: "userPassword")
    }

    func retrieveCredentialsFromKeychain() {
        if let storedUsername = KeychainWrapper.standard.string(forKey: "userUsername"),
           let storedPassword = KeychainWrapper.standard.string(forKey: "userPassword") {
            self.username = storedUsername
            self.password = storedPassword
            self.rememberPassword = true
        }
    }

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Login using FaceID!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        signInWithUsernamePassword() // Proceed with login
                    } else {
                        showAlert(message: "FaceID Authentication Failed")
                    }
                }
            }
        } else {
            showAlert(message: "FaceID not available")
        }
    }

    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    // Connection to Firestore using username
    func signInWithUsernamePassword() {
        // Fetch user's email from Firestore using the username
        let usersRef = db.collection("user") 
        let query = usersRef.whereField("username", isEqualTo: username).limit(to: 1)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                showAlert(message: "Error fetching user data: \(error.localizedDescription)")
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = querySnapshot?.documents.first {
                let email = document.data()["email"] as? String
                // Proceed to sign in with email and password
                if let email = email {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            showAlert(message: "Login failed. Please check your credentials.")
                            print("Error signing in: \(error.localizedDescription)")
                            return
                        }
                        
                        if let user = result?.user {
                            // Successfully logged in
                            isLoggedIn = true
                            print("User logged in successfully: \(user.uid)")
                        }
                    }
                } else {
                    showAlert(message: "No user found with this username.")
                }
            } else {
                showAlert(message: "No user found with this username.")
            }
        }
    }


    func showAlert(message: String) {
        alertMessage = AlertMessage(message: message)
    }

    struct AlertMessage: Identifiable {
        let id = UUID()
        let message: String
    }
}

#Preview {
    ContentView()
}
