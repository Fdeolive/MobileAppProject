//
//  DBFriendConnect.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBFriendConnect {
    // Get db
    let db = Firestore.firestore()
    
    // Function to read all notifications from Firebase into the NotificationStore
    // NOTE: Only reads in notifications that the NotificationStore doesn't already have
    func getFriends(friendStore: FriendStore) async {
        DispatchQueue.main.async {
            friendStore.allFriends = []
        }
        let docRef = db.collection("user").document("cking")
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
                if document.get("friends.\("cking")") as? Bool ?? true == false {
                    try await db.collection("user").document("cking").updateData(["friends.\(friendUsername)": true])
                    try await db.collection("user").document("\(friendUsername)").updateData(["friends.\("cking")": true])
                } else {
                    try await db.collection("user").document("cking").updateData(["friends.\(friendUsername)": false])
                    // Technically not unique
                    let newNotification = Notification("cking wants to be your friend", "hi")
                    try await db.collection("user").document("\(friendUsername)").updateData(["notifications.\(newNotification.notificationId).notificationTitle": newNotification.notificationTitle,"notifications.\(newNotification.notificationId).notificationSummary": newNotification.notificationSummary])
                }
            } else if friendStatus == 2 {
                try await db.collection("user").document("cking").updateData(["friends.\(friendUsername)": true])
            } else {
                try await db.collection("user").document("cking").updateData(["friends.\(friendUsername)": FieldValue.delete()])
                try await db.collection("user").document(friendUsername).updateData(["friends.\("cking")": FieldValue.delete()])
            }
            print("Doc updated successfully")
        } catch {
            print("Error updating doc")
        }
    }
    
    
    // Function for deleting notifications from Firebase
    func deleteFriend(friend: Friend) async {
        
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



