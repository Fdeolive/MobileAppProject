import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    var user: User?

    // Main Color
    private let darkGreen = Color(red: 50 / 255, green: 150 / 255, blue: 50 / 255)

    // Connection to Firebase
    let db = Firestore.firestore()

    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    // Use @StateObject for Item to ensure reactivity
    @StateObject var item = Item() // Only declare item here as @StateObject

    // Navigation states for buttons
    @State private var showChangePasswordView = false
    @State private var showBookshelfView = false

    // Bio-related states
    @State private var bio: String = "" // No default bio, load from Firestore
    @State private var isLoading: Bool = true
    @State private var isSaving: Bool = false // Track save state
    @State private var username: String? // Store the user's username

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    // Display the username above the profile picture with adjusted font size
                    if let username = username {
                        Text("\(username)'s Profile")
                            .font(.title3) // Smaller font size
                            .fontWeight(.semibold) // Adjust weight for balance
                            .padding(.bottom, 8) // Reduced padding
                    }

                    Section {
                        // Display the profile picture as a circular image
                        if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120) // Smaller profile picture
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .shadow(radius: 4)
                                .padding(.bottom, 12) // Reduced bottom padding
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 120) // Smaller profile picture
                                .overlay(Text("No Image").foregroundColor(.gray))
                                .padding(.bottom, 12) // Reduced bottom padding
                        }

                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Label("Change Profile Picture", systemImage: "photo")
                                .padding(8)
                                .frame(width: 180, height: 35) // Smaller button size
                                .background(darkGreen)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 8) // Reduced bottom padding
                        .onChange(of: selectedPhoto) { newPhoto in
                            Task {
                                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                    item.image = data
                                }
                            }
                        }

                        if item.image != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    selectedPhoto = nil
                                    item.image = nil
                                }
                            } label: {
                                Label("Remove Profile Picture", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                            .padding(.bottom, 20)
                        }
                        
                        // Add buttons for other profile features
                        VStack(spacing: 20) {
                            Button("Change Password") {
                                showChangePasswordView = true
                            }
                            .buttonStyle(ProfileButtonStyle())
                            
                            Button("Change Username") {
                                showChangeUsernameView = true
                            }
                            .buttonStyle(ProfileButtonStyle())
                            
                            Button("View My Bookshelf") {
                                showBookshelfView = true
                            }
                            .buttonStyle(ProfileButtonStyle())
                            Button("Log Out") {
                                isLoggedIn = false
                                
                            }.buttonStyle(ProfileButtonStyle())
                        }
                        .padding(.top, 20)
                    }
                    
                        Text("Bio")
                            .font(.headline) // Keep default for Bio title

                        if isLoading {
                            ProgressView("Loading...")
                        } else {
                            TextField("Enter your bio", text: $bio)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Button("Save Bio") {
                            saveBio()
                        }
                        .buttonStyle(ProfileButtonStyle())
                        .padding(.top, 8)
                        .frame(alignment: .center)
                        .disabled(isSaving)
                    }
                    .padding(.horizontal, 8)

                    VStack(spacing: 8) { // Reduced spacing between buttons
                        Button("Change Password") {
                            showChangePasswordView = true
                        }
                        .buttonStyle(ProfileButtonStyle())

                        Button("View My Bookshelf") {
                            showBookshelfView = true
                        }
                        .buttonStyle(ProfileButtonStyle())
                    }
                    .padding(.top, 8) // Reduced top padding for buttons
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear(perform: loadUserAndBio) // Load both user and bio
                .navigationDestination(isPresented: $showChangePasswordView) {
                    ChangePasswordView()
                }
                .navigationDestination(isPresented: $showBookshelfView) {
                    ShelfView()
                }
            }
        }
    }

    private func loadUserAndBio() {
        // Fetch the current logged-in user's UID from Firebase Authentication
        guard let currentUser = Auth.auth().currentUser else {
            print("Error: No user is logged in")
            isLoading = false
            return
        }

        // Fetch the user's username using the UID
        let userId = currentUser.uid
        print("Fetching username for user with uid: \(userId)") // Debug log

        db.collection("user").whereField("uid", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                isLoading = false
                return
            }

            // Ensure that a document was found for the user
            guard let document = snapshot?.documents.first else {
                print("No user document found with uid: \(userId)")
                isLoading = false
                return
            }

            // Get the username from the document
            self.username = document.documentID
            print("Found username: \(self.username ?? "unknown")") // Debug log

            // Now fetch the bio from the document
            let bioData = document.data()["bio"] as? String ?? "" // Empty if not found
            self.bio = bioData
            isLoading = false
        }
    }

    private func saveBio() {
        // Ensure that we have the username to update the document
        guard let username = username else {
            print("Error: Username is missing")
            return
        }

        // Show loading state while saving
        isSaving = true
        print("Saving bio for username: \(username): \(bio)") // Debug log

        db.collection("user").document(username).updateData(["bio": bio]) { error in
            isSaving = false // Re-enable button after saving

            if let error = error {
                print("Error saving bio: \(error.localizedDescription)")
            } else {
                print("Bio successfully updated!")
            }
        }
    }
}

#Preview {
    @Previewable @State var isLoggedIn = true
    ProfileView(isLoggedIn: $isLoggedIn)
}
