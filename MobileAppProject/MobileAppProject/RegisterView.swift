//
//  RegisterView.swift
//  Register Page, Book Hunter Project
//
//  Created by Grace E Kinney on 10/23/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseFirestore

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var registrationSuccess = false
    @State private var showMessage = false
    
    // State for optional checkbox
    @State private var rememberPassword = false
    
    // Password visibility
    @State private var isPasswordVisible = false
    
    // State for username
    @State private var username = ""
    
    // State to check if username is available and valid
    @State private var isUsernameValid = false
    
    // State for registration error
    @State private var registrationError: String?
    
    // State to track if the user is currently typing
        @State private var isTypingUsername = false
    
    // Main Color
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dark green background
                Color(darkGreen).ignoresSafeArea()
                
                Rectangle()
                    .trim(from: 0.0, to: 0.5)
                    .frame(width: 1000, height: 1000)
                    .foregroundColor(.white)
                
                // White foreground circle
                Circle()
                    .frame(width: 700.0, height: 800)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .offset(y: -100)
                    
                    // Navigation Links for Login and Register
                    HStack {
                        NavigationLink("Login", destination: ContentView())
                            .foregroundColor(.blue)
                       
                        Spacer()
                            .frame(width: 75)
                        
                        NavigationLink("Register", destination: RegisterView())
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 50)
                    .offset(y: -60)
                    
                    // Username field
                    HStack {
                                            Image(systemName: "person")
                                                .foregroundColor(.black.opacity(0.5))
                                            TextField("Username", text: $username, onEditingChanged: { isEditing in
                                                isTypingUsername = isEditing // Track when user starts or stops typing
                                                
                                                if !isEditing {
                                                    // Check if the username is available only after the user stops typing
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        checkUsernameAvailability(username)
                                                    }
                                                }
                                            }).autocapitalization(.none)
                                        }
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(getUsernameFieldColor())  // Use function to get the correct color
                                        .cornerRadius(10)
                                        .offset(y: -90)
                    
                    // Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.black.opacity(0.5))
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .offset(y: -75)

                    // Password field
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
                    .offset(y: -65)
                    
                    // Remember Password Toggle
                    Toggle(isOn: $rememberPassword) {
                        Text("Remember Me")
                            .foregroundColor(.black)
                            .font(.body)
                    }
                    .padding()
                    .frame(width: 300)
                    .offset(y: -35)

                    // Register Button
                    Button("Register") {
                        // Reset error state
                        registrationError = nil
                        register()
                    }
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .offset(y: -25)
                }
                .alert(isPresented: $showMessage) {
                    if registrationError != nil {
                        return Alert(title: Text("Registration Failed"),
                                     message: Text(registrationError ?? "Unknown error"),
                                     dismissButton: .default(Text("Try Again")))
                    } else {
                        return Alert(title: Text("Registration Successful"),
                                     message: Text("You have successfully registered your account for Book Hunter. Please login to get started!"),
                                     dismissButton: .default(Text("Go to Login Page")) {
                            registrationSuccess = true
                        })
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            // Switch back to Login
            .navigationDestination(isPresented: $registrationSuccess) {
                ContentView()
            }
            .onAppear {
                retrieveCredentialsFromKeychain()  // Retrieve credentials on view load
            }
        }
    }
    
    // Get the background color based on the username field state
    func getUsernameFieldColor() -> Color {
            if username.isEmpty {
                return Color.black.opacity(0.05)  // Default grey when no content
            } else if isTypingUsername {
                return Color.black.opacity(0.05)  // Grey while typing
            } else if isUsernameValid {
                return Color.green.opacity(0.1)  // Green if valid username
            } else {
                return Color.red.opacity(0.1)  // Red if username already taken
            }
        }
    
    // Check if username is available in Firebase
        func checkUsernameAvailability(_ username: String) {
            let db = Firestore.firestore()
            db.collection("user").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking username availability: \(error.localizedDescription)")
                    return
                }
                
                // If no documents, username is available
                DispatchQueue.main.async {
                    isUsernameValid = snapshot?.documents.isEmpty ?? true
                }
            }
        }

    // Register User
    func register() {
           // Validate input fields and username availability
           guard !email.isEmpty, !password.isEmpty, isUsernameValid else {
               // Show error if fields are empty or username is invalid
               registrationError = "Please fill in all fields correctly."
               showMessage = true
               return
           }

           // Create user with Firebase Authentication
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if let error = error {
                   registrationError = "Firebase Auth Error: \(error.localizedDescription)"
                   showMessage = true
                   return
               }
               
               // Hash password and store additional user data in Firestore
               if let user = authResult?.user {
                   let hashedPassword = hashPassword(password)
                   
                   // Save user data to Firestore
                   let registerNotification = Notification("Welcome to Book Hunting!", "Thanks for joining our book hunting app. what are you waiting for? Go explore the app and it's features!")
                   let userData: [String: Any] = [
                       "email": email,
                       "username": username,
                       "hashedPassword": hashedPassword,
                       "uid": user.uid,
                       "notifications": [
                        "\(registerNotification.notificationId)": [
                        "notificationTitle": "\(registerNotification.notificationTitle)",
                        "notificationSummary": "\(registerNotification.notificationSummary)"
                        ]],
                        "friends": ["default": true]
                   ]

                   let db = Firestore.firestore()
                   db.collection("user").document(username).setData(userData) { error in
                       if let error = error {
                           registrationError = "Error storing user data: \(error.localizedDescription)"
                           showMessage = true
                       } else {
                           // Save credentials to Keychain if 'Remember Password' is checked
                           if rememberPassword {
                               saveCredentialsToKeychain(email: email, password: password)
                           }
                           
                           // Display success message
                           registrationSuccess = true
                           showMessage = true
                       }
                   }
                   DBFriendConnect(username: username).callUpdateFriendStatus(friendUsername: "default", friendStatus: 0)
               }
           }
       }
    
    // Save Credentials to Keychain
    func saveCredentialsToKeychain(email: String, password: String) {
        KeychainWrapper.standard.set(email, forKey: "userEmail")
        KeychainWrapper.standard.set(password, forKey: "userPassword")
        KeychainWrapper.standard.set(username, forKey: "userUsername")
    }

    // Retrieve Credentials from Keychain
    func retrieveCredentialsFromKeychain() {
        if let storedEmail = KeychainWrapper.standard.string(forKey: "userEmail"),
               let storedPassword = KeychainWrapper.standard.string(forKey: "userPassword"),
               let storedUsername = KeychainWrapper.standard.string(forKey: "userUsername") {
                self.email = storedEmail
                self.password = storedPassword
                self.username = storedUsername
                self.rememberPassword = true
        }
    }
    
    // Simple password hashing function (placeholder)
    func hashPassword(_ password: String) -> String {
        return String(password.reversed())  // Simple example, replace with a secure hashing method
    }
}

#Preview {
    RegisterView()
}
