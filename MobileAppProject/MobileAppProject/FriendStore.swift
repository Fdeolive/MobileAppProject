//
//  FriendStore.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import Foundation

class FriendStore: ObservableObject {
    
    @Published var allFriends: [Friend]
    // Setting to true turns on loading persisted data
    // NOTE: Will cause preview to crash/only works in simulator
    // Reset to false to play around in preview!
    
    // Load saved data if loadFromFile
    // Else load no data and start with empty list of notifications
    init() {
        allFriends = [Friend("Joe", 1), Friend("John", 2), Friend("Sam", 2)]
    }
    
    // Function to delete notifications from the NotificationStore
    func delete(friend: Friend!) {
        if let idx = allFriends.firstIndex(where: {$0.friendId == friend.friendId}) {
            allFriends.remove(at: idx)
        }
    }
}
