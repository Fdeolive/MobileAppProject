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
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let friends = document.get("friends") as? [String] {
                for friendOne in friends {
                    var alreadyInStore = false
                    for friendTwo in friendStore.allFriends {
                        if "\(friendTwo.friendUsername)" == friendOne {
                            alreadyInStore = true
                        }
                    }
                    if alreadyInStore == false {
                        friendStore.allFriends.append(Friend(friendOne))
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
    func updateFriends(friendStore: FriendStore) async {
        
    }
    
    // Function for deleting notifications from Firebase
    func deleteFriend(friend: Friend) async {
        
    }
}



