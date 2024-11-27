import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ChangeUsernameView: View {
    // Reference to the current authenticated user
    var user: User?
    let db = Firestore.firestore()

    // States
    @State private var currentUsername: String?
    @State private var newUsername: String = ""
    @State private var isLoading: Bool = true
    @State private var isSaving: Bool = false
    @State private var showMessage = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var isUsernameValid: Bool = false // Track the validity of the new username
    @State private var isTypingUsername: Bool = false // Track if user is typing

    @State private var navigateBackToProfile = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    // Display current username
                    if let currentUsername = currentUsername {
                        Text("\(currentUsername)'s Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }

                    // New username text field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.black.opacity(0.5))
                        TextField("New Username", text: $newUsername, onEditingChanged: { isEditing in
                            isTypingUsername = isEditing
                            
                            if !isEditing {
                                // Only check after the user stops typing
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    checkUsernameAvailability(newUsername)
                                }
                            }
                        })
                        .autocapitalization(.none)
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(getUsernameFieldColor()) // Get dynamic field color
                    .cornerRadius(10)
                    .padding(.bottom, 20)

                    // Save username button
                    Button("Save Username") {
                        saveUsername()
                    }
                    .buttonStyle(ProfileButtonStyle())
                    .padding(.top, 10)
                    .disabled(isSaving || newUsername.isEmpty || !isUsernameValid)

                    Spacer()

                    // Back to Profile button
                    Button("Back to Profile") {
                        navigateBackToProfile = true
                    }
                    .buttonStyle(ProfileButtonStyle())
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear(perform: loadCurrentUsername)
                .navigationDestination(isPresented: $navigateBackToProfile) {
                    ProfileView()
                }
            }
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

    // Get the background color based on the username field state
    func getUsernameFieldColor() -> Color {
        if newUsername.isEmpty {
            return Color.black.opacity(0.05) // Default grey when no content
        } else if isTypingUsername {
            return Color.black.opacity(0.05) // Grey while typing
        } else if isUsernameValid {
            return Color.green.opacity(0.1) // Green if valid username
        } else {
            return Color.red.opacity(0.1) // Red if username already taken
        }
    }

    // Fetch current username from Firestore
    private func loadCurrentUsername() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Error: No user is logged in")
            isLoading = false
            return
        }

        let userId = currentUser.uid
        db.collection("user").whereField("uid", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                isLoading = false
                return
            }

            guard let document = snapshot?.documents.first else {
                print("No user document found with uid: \(userId)")
                isLoading = false
                return
            }

            self.currentUsername = document.documentID
            self.newUsername = self.currentUsername ?? ""
            isLoading = false
        }
    }

    // Check if the new username is available (not already in use)
    private func checkUsernameAvailability(_ username: String) {
        db.collection("user").document(username).getDocument { (document, error) in
            if let error = error {
                print("Error checking username availability: \(error.localizedDescription)")
                return
            }

            // If document exists, username is already taken
            DispatchQueue.main.async {
                isUsernameValid = document?.exists == false
            }
        }
    }

    // Save the new username to Firestore
    private func saveUsername() {
        guard !newUsername.isEmpty else {
            print("Error: Username cannot be empty")
            return
        }

        isSaving = true

        // Check if current username is same as the new username
        guard currentUsername != newUsername else {
            showMessage = true
            errorMessage = "Your new username is the same as the current username."
            successMessage = nil
            isSaving = false
            return
        }

        // Proceed with username change if new username is available
        if !isUsernameValid {
            showMessage = true
            errorMessage = "This username is already taken. Please choose another one."
            successMessage = nil
            isSaving = false
            return
        }

        // Update the user's username in Firestore
        let userRef = db.collection("user").document(currentUsername ?? "")
        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                isSaving = false
                showMessage = true
                errorMessage = "Failed to fetch user data."
                successMessage = nil
            } else if let document = documentSnapshot, document.exists {
                // Copy the user data to the new username document
                var userData = document.data() ?? [:]

                // Create new document with the new username
                db.collection("user").document(newUsername).setData(userData) { error in
                    if let error = error {
                        print("Error creating new user document: \(error.localizedDescription)")
                        isSaving = false
                        showMessage = true
                        errorMessage = "Failed to create new user document."
                        successMessage = nil
                    } else {
                        // Update the 'username' field in the new document
                        db.collection("user").document(newUsername).updateData(["username": newUsername]) { error in
                            if let error = error {
                                print("Error updating username field in new document: \(error.localizedDescription)")
                                isSaving = false
                                showMessage = true
                                errorMessage = "Failed to update username field."
                                successMessage = nil
                            } else {
                                // Update the username in all other relevant fields, like the username document ID
                                db.collection("user").whereField("username", isEqualTo: currentUsername).getDocuments { (snapshot, error) in
                                    if let error = error {
                                        print("Error fetching documents to update username field: \(error.localizedDescription)")
                                        return
                                    }

                                    for document in snapshot?.documents ?? [] {
                                        document.reference.updateData(["username": newUsername]) { error in
                                            if let error = error {
                                                print("Error updating username field: \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }

                                // Delete the old document after creating the new one
                                userRef.delete { error in
                                    if let error = error {
                                        print("Error deleting old document: \(error.localizedDescription)")
                                        isSaving = false
                                        showMessage = true
                                        errorMessage = "Failed to delete old document."
                                        successMessage = nil
                                    } else {
                                        print("Successfully updated username!")
                                        isSaving = false
                                        successMessage = "Your username has been successfully updated!"
                                        errorMessage = nil
                                        showMessage = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ChangeUsernameView()
}
