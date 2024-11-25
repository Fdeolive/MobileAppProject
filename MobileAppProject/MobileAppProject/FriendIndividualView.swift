// View of a friends profile
// FriendIndividualView.swift
// MobileAppProject
// Carson J. King

import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct FriendIndividualView: View {
    
    @EnvironmentObject var friendStore: FriendStore
    @State var friendUsername: String
    @State var buttonText = ""
    @State var friendStatus = 0
    
    func updateFriendStatus() {
        var friendFound = false
        for friend in friendStore.allFriends {
            if friend.friendUsername == friendUsername {
                friendFound = true
                if friend.friendStatus == 1 || friend.friendStatus == 2 {
                    friendStore.delete(friend: friend)
                    friendStatus = 0
                    buttonText = "Add Friend"
                }
            }
        }
        if friendFound == false {
            friendStore.allFriends.append(Friend(friendUsername, 1))
            friendStatus = 1
            buttonText = "Cancel Request"
        }
        Task {
            do {
                await DBFriendConnect(username: "cking").updateFriendStatus(friendUsername: friendUsername, friendStatus:  friendStatus)
            }
        }
    }
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    var user: User?
    
    // Main Color
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    // Use @StateObject for Item to ensure reactivity
    @StateObject var item = Item()
    @State private var showBookshelfView = false
    
    var body: some View {
        NavigationView {
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
                        Text(friendUsername)
                        FilterButtonView(buttonText: buttonText, action: { updateFriendStatus() })
                        
                        // Add buttons for other profile features
                        VStack(spacing: 20) {
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
                
                .navigationDestination(isPresented: $showBookshelfView) {
                    ShelfView()
                }
            }.onAppear {
                var friendFound = false
                for friend in friendStore.allFriends {
                    if friend.friendUsername == friendUsername {
                        friendStatus = friend.friendStatus
                        friendFound = true
                    }
                }
                if friendFound == false {
                    friendStatus = 0
                }
                switch friendStatus {
                case 0:
                    buttonText = "Add Friend"
                case 1:
                    buttonText = "Cancel Request"
                default:
                    buttonText = "Remove Friend"
                }
            }
        }
        
    }
}

#Preview {
    FriendIndividualView(friendUsername: "Joe")
        .environmentObject(FriendStore())
}
