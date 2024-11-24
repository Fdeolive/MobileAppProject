// Class for storing friends
// FriendStore.swift
// MobileAppProject
// Carson J. King

import Foundation

class FriendStore: ObservableObject {
    
    @Published var allFriends: [Friend]
    init() {
        allFriends = []
    }
    
    // Function to delete notifications from the NotificationStore
    func delete(friend: Friend!) {
        if let idx = allFriends.firstIndex(where: {$0.friendId == friend.friendId}) {
            allFriends.remove(at: idx)
        }
    }
}
