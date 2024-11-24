//
//  ProfileView.swift
//  MobileAppProject
//
//  Created by user264318 on 11/11/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

struct ProfileView: View {
    var user: User?
    
    // Main Color
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    
    // Connection to Firebase
    let db = Firestore.firestore()
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    // Use @StateObject for Item to ensure reactivity
    @StateObject var item = Item()  // Only declare item here as @StateObject
    
    // Navigation states for buttons
    @State private var showChangePasswordView = false
    @State private var showChangeEmailView = false
    @State private var showChangeUsernameView = false
    @State private var showBookshelfView = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer() // Pushes content to the center vertically
                    
                    Section {
                        // Display the profile picture as a circular image
                        if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150) // Fixed size for the profile picture
                                .clipShape(Circle()) // Make it a circle
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2)) // Add a border
                                .shadow(radius: 5) // Optional shadow for styling
                                .padding(.bottom, 20)
                        } else {
                            // Placeholder if there's no profile picture
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(Text("No Image").foregroundColor(.gray))
                                .padding(.bottom, 20)
                        }
                        
                        // PhotosPicker to select a new profile picture
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Label("Change Profile Picture", systemImage: "photo")
                                .padding()
                                .background(darkGreen)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 10)
                        // Use .onChange to update the image when a new photo is selected
                        .onChange(of: selectedPhoto) { newPhoto in
                            Task {
                                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                    item.image = data
                                }
                            }
                        }
                        
                        // Remove Image button if a profile picture exists
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
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer() // Pushes content to the center vertically
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center horizontally and vertically
                .navigationDestination(isPresented: $showChangePasswordView) {
                    ChangePasswordView()
                }
                .navigationDestination(isPresented: $showChangeUsernameView) {
                    ChangeUsernameView()
                }
                .navigationDestination(isPresented: $showBookshelfView) {
                    ShelfView()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
