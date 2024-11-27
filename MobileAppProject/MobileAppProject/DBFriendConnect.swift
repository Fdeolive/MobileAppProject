// Struct for connections to firebase
// DBFriendConnect.swift
// MobileAppProject
// Carson J. King

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBFriendConnect {
    // Get db
    let db = Firestore.firestore()
    private var username = ""
    
    init(username: String) {
        self.username = username
    }
    
    func callGetFriends(friendStore: FriendStore) {
        Task {
            do {
                await getFriends(friendStore: friendStore)
            }
        }
    }
    
    func callUpdateFriendStatus(friendUsername: String, friendStatus: Int) {
        Task {
            do {
                await updateFriendStatus(friendUsername: friendUsername, friendStatus: friendStatus)
            }
        }
    }
    
    func callFindUserToFriend(friendStore: FriendStore, foundUser: FoundUser, friendSearch: String) {
        Task {
            do {
                await findUserToFriend(friendStore: friendStore, foundUser: foundUser, friendSearch: friendSearch)
            }
        }
    }
    
    // Function to read all notifications from Firebase into the NotificationStore
    func getFriends(friendStore: FriendStore) async {
        DispatchQueue.main.async {
            friendStore.allFriends = []
        }
        let docRef = db.collection("user").document("\(username)")
        do {
            let document = try await docRef.getDocument()
            if let friends = document.get("friends") as? [String:Bool] {
                for (id, value) in friends {
                    DispatchQueue.main.async {
                        if value {
                            friendStore.allFriends.append(Friend(id, 2))
                        } else {
                            friendStore.allFriends.append(Friend(id, 1))
                        }
                    }
                }
            } else {
                print("Nope")
            }
        } catch {
            print("Error retrieving document")
        }
    }
    
    // Function for updating/adding notifications to Firebase
    func updateFriendStatus(friendUsername: String, friendStatus: Int) async {
        do {
            if friendStatus == 1 {
                let document = try await db.collection("user").document("\(friendUsername)").getDocument()
                if document.get("friends.\(username)") as? Bool ?? true == false {
                    try await db.collection("user").document("\(username)").updateData(["friends.\(friendUsername)": true])
                    try await db.collection("user").document("\(friendUsername)").updateData(["friends.\(username)": true])
                } else {
                    try await db.collection("user").document("\(username)").updateData(["friends.\(friendUsername)": false])
                    // Technically not unique
                    let newNotification = Notification("\(username) wants to be your friend", "You got a friend request from \(username). Search for their name in the friends tab to add them!", UUID(), "\(username)")
                    try await db.collection("user").document("\(friendUsername)").updateData(["notifications.\(newNotification.notificationId).notificationTitle": newNotification.notificationTitle,"notifications.\(newNotification.notificationId).notificationSummary": newNotification.notificationSummary])
                }
            } else if friendStatus == 2 {
                try await db.collection("user").document("\(username)").updateData(["friends.\(friendUsername)": true])
            } else {
                try await db.collection("user").document("\(username)").updateData(["friends.\(friendUsername)": FieldValue.delete()])
                try await db.collection("user").document(friendUsername).updateData(["friends.\("\(username)")": FieldValue.delete()])
            }
            print("Doc updated successfully")
        } catch {
            print("Error updating doc")
        }
    }
    
    func findUserToFriend(friendStore: FriendStore, foundUser: FoundUser, friendSearch: String) async {
        let colRef =  db.collection("user").whereField("username", isEqualTo: friendSearch)
        do {
            let documents = try await colRef.getDocuments()
            if documents.documents.count > 0 {
                var alreadyFriends = false
                for friend in friendStore.allFriends {
                    if friend.friendUsername == friendSearch {
                        alreadyFriends = true
                    }
                }
                if alreadyFriends {
                    DispatchQueue.main.async {
                        foundUser.userStatus = 3
                        foundUser.username = friendSearch
                    }
                } else {
                    DispatchQueue.main.async {
                        foundUser.userStatus = 2
                        foundUser.username = friendSearch
                    }
                }
            } else {
                DispatchQueue.main.async {
                    foundUser.userStatus = 1
                }
            }
            print("Doc retrieved successfully")
        } catch {
            print("Error getting documents")
        }
    }
}
