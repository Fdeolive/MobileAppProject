//
//  ChangeUsernameView.swift
//  MobileAppProject
//
//  Created by user264318 on 11/19/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseFirestore

struct ChangeUsernameView: View {
    @State private var newUsername = ""
    @State private var isUsernameValid = false
    @State private var isTypingUsername = false
    @State private var showMessage = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var isCheckingUsername = false
    
    var body: some View {
        VStack {
            Text("Change Username")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Username field
            TextField("New Username", text: $newUsername, onEditingChanged: { isEditing in
                isTypingUsername = isEditing
                if !isEditing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        checkUsernameAvailability(newUsername)
                    }
                }
            }).autocapitalization(.none)
            .padding()
            .background(getUsernameFieldColor())
            .cornerRadius(10)
            .padding()
            
            Button("Update Username") {
                if !isCheckingUsername {
                    isCheckingUsername = true
                    checkUsernameAvailability(newUsername)
                }
            }
            .buttonStyle(ProfileButtonStyle())
            .disabled(isCheckingUsername || newUsername.isEmpty)
        }
        .alert(isPresented: $showMessage) {
            if let successMessage = successMessage {
                return Alert(
                    title: Text("Success"),
                    message: Text(successMessage),
                    dismissButton: .default(Text("OK"))
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Reuse the function to check username availability
    func checkUsernameAvailability(_ username: String) {
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty."
            showMessage = true
            isCheckingUsername = false
            return
        }
        
        let db = Firestore.firestore()
        db.collection("user").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error checking username availability: \(error.localizedDescription)")
                isCheckingUsername = false
                return
            }
            
            if let snapshot = snapshot, snapshot.documents.isEmpty {
                // Username is valid, update it
                DispatchQueue.main.async {
                    isUsernameValid = true
                    errorMessage = nil
                    updateUsername(username)
                }
            } else {
                // Username is already taken
                DispatchQueue.main.async {
                    isUsernameValid = false
                    errorMessage = "Username is already taken."
                    showMessage = true
                    isCheckingUsername = false
                }
            }
        }
    }
    
    // Function to handle updating the username in Firebase
    func updateUsername(_ username: String) {
        let currentUser = Auth.auth().currentUser
        if let user = currentUser {
            let db = Firestore.firestore()
            let userRef = db.collection("user").document(user.uid)
            userRef.updateData([
                "username": username
            ]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                    isCheckingUsername = false
                } else {
                    print("Username successfully updated to \(username)")
                    DispatchQueue.main.async {
                        successMessage = "Your username has been successfully updated!"
                        showMessage = true
                        isCheckingUsername = false
                    }
                }
            }
        }
    }
    
    // Get the color for the username field
    func getUsernameFieldColor() -> Color {
        if newUsername.isEmpty {
            return Color.black.opacity(0.05)  // Default grey
        } else if isTypingUsername {
            return Color.black.opacity(0.05)  // Grey while typing
        } else if isUsernameValid {
            return Color.green.opacity(0.1)  // Green if valid username
        } else {
            return Color.red.opacity(0.1)  // Red if invalid username
        }
    }
}

#Preview {
    ChangeUsernameView()
}
