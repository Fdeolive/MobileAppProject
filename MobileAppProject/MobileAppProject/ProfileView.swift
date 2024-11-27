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
    @StateObject var item = Item()

    // Navigation states for buttons
    @State private var showChangePasswordView = false
    @State private var showBookshelfView = false

    // Bio-related states
    @State private var bio: String = ""
    @State private var isLoading: Bool = true
    @State private var isSaving: Bool = false
    @State private var username: String?

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    // Display the username above the profile picture with adjusted font size
                    if let username = username {
                        Text("\(username)'s Profile")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                    }

                    Section {
                        // Display the profile picture as a circular image
                        if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .shadow(radius: 4)
                                .padding(.bottom, 12)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 120)
                                .overlay(Text("No Image").foregroundColor(.gray))
                                .padding(.bottom, 12)
                        }

                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Label("Change Profile Picture", systemImage: "photo")
                                .padding(8)
                                .frame(width: 180, height: 35)
                                .background(darkGreen)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 8)
                        .onChange(of: selectedPhoto) { newPhoto in
                            Task {
                                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                    item.image = data
                                }
                            }
                        }

                        // Remove profile picture button if an image is selected
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

                        // Bio Section
                        Text("Bio")
                            .font(.headline)

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

                    // Profile Actions (buttons)
                    VStack(spacing: 20) {
                        Button("Change Password") {
                            showChangePasswordView = true
                        }
                        .buttonStyle(ProfileButtonStyle())

                        Button("View My Bookshelf") {
                            showBookshelfView = true
                        }
                        .buttonStyle(ProfileButtonStyle())

                        Button("Log Out") {
                            isLoggedIn = false
                        }
                        .buttonStyle(ProfileButtonStyle())
                    }
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear(perform: loadUserAndBio)
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

        let userId = currentUser.uid
        print("Fetching username for user with uid: \(userId)")

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

            self.username = document.documentID
            print("Found username: \(self.username ?? "unknown")")

            self.bio = document.data()["bio"] as? String ?? ""
            isLoading = false
        }
    }

    private func saveBio() {
        guard let username = username else {
            print("Error: Username is missing")
            return
        }

        isSaving = true
        print("Saving bio for username: \(username): \(bio)")

        db.collection("user").document(username).updateData(["bio": bio]) { error in
            isSaving = false

            if let error = error {
                print("Error saving bio: \(error.localizedDescription)")
            } else {
                print("Bio successfully updated!")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
    }
}


#Preview {
    @Previewable @State var isLoggedIn = true
    ProfileView(isLoggedIn: $isLoggedIn)
}
