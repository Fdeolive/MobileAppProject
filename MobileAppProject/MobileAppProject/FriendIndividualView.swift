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
    @EnvironmentObject var username: Username
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
                await DBFriendConnect(username: username.username).updateFriendStatus(friendUsername: friendUsername, friendStatus:  friendStatus)
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
                    Text("\(friendUsername)'s Profile")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                    Section {
                        // Display the profile picture as a circular image
                        
                            // Placeholder if there's no profile picture
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(Text("No Image").foregroundColor(.gray))
                                .padding(.bottom, 20)
                        
                        Text("Bio")
                            .font(.headline)
                        Text("Under development")
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    FriendShelfView()
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
        .environmentObject(Username())
}
