//
//  ChangePasswordView.swift
//  MobileAppProject
//
//  Created by user264318 on 11/19/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var showAlert = false
    
    // Separate visibility toggles for each field
    @State private var isCurrentPasswordVisible = false
    @State private var isNewPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var body: some View {
        VStack {
            Text("Change Password")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Form {
                // Current Password Field
                Section(header: Text("Current Password")) {
                    HStack {
                        if isCurrentPasswordVisible {
                            TextField("Enter current password", text: $currentPassword)
                                .textContentType(.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Enter current password", text: $currentPassword)
                        }
                        Button(action: {
                            isCurrentPasswordVisible.toggle()
                        }) {
                            Image(systemName: isCurrentPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                }.padding(10)
                
                // New Password Field
                Section(header: Text("New Password")) {
                    HStack {
                        if isNewPasswordVisible {
                            TextField("Enter new password", text: $newPassword)
                                .textContentType(.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Enter new password", text: $newPassword)
                        }
                        Button(action: {
                            isNewPasswordVisible.toggle()
                        }) {
                            Image(systemName: isNewPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                }.padding(10)
                
                // Confirm New Password Field
                Section(header: Text("Confirm New Password")) {
                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Re-enter new password", text: $confirmNewPassword)
                                .textContentType(.password)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Re-enter new password", text: $confirmNewPassword)
                        }
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                }.padding(10)
                
            }
            .background(Color.green.opacity(0.1))
            .scrollContentBackground(.hidden)
            .frame(width: 400, height: 450)
            
            // Button to Change Password
            Button(action: {
                changePassword()
            }) {
                Text("Change Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding()
            
            // Error Message Display
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Password changed successfully!"), dismissButton: .default(Text("OK")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // Method to change password
    private func changePassword() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not logged in"
            return
        }
        
        if newPassword != confirmNewPassword {
            errorMessage = "New passwords do not match"
            return
        }
        
        // Re-authenticate the user
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            
            // Hash and Update password
            let hashedPassword = hashPassword(newPassword)
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                } else {
                    saveNewPasswordToFirestore(user: user, hashedPassword: hashedPassword)
                }
            }
        }
    }
    
    // Save hashed password to Firestore securely
    private func saveNewPasswordToFirestore(user: User, hashedPassword: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "hashedPassword": hashedPassword
        ]
        
        db.collection("user").document(user.uid).updateData(userData) 
    }
    
    // Simple password hashing function (placeholder)
    func hashPassword(_ password: String) -> String {
        return String(password.reversed())
    }
}

#Preview {
    ChangePasswordView()
}
