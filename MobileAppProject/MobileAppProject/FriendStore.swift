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
    let loadFromFile = true
    let bundlesFilename = "friend-init.json"
    
    // Path to json file
    let friendArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("friends.json")
    } ()
    
    // Load saved data if loadFromFile
    // Else load no data and start with empty list of notifications
    init() {
        if loadFromFile {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: friendArchiveURL.path) {
                print("load from \(friendArchiveURL.path)")
                self.allFriends = load(friendArchiveURL)
            } else {
                if let url = Bundle.main.url(forResource: bundlesFilename, withExtension: nil) {
                    print("load from \(url.path)")
                    self.allFriends = load(url)
                } else {
                    fatalError("Can't find file to load")
                }
            }
        }else {
            allFriends = []
        }
    }
    
    // Save changes to json file
    @discardableResult
    func saveChanges() -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allFriends)
            try data.write(to: friendArchiveURL, options: [.atomic])
            print("Saved data to \(friendArchiveURL)")
            print(allFriends)
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
    
    // Function to delete notifications from the NotificationStore
    func delete(friend: Friend!) {
        if let idx = allFriends.firstIndex(where: {$0.friendId == friend.friendId}) {
            allFriends.remove(at: idx)
        }
    }
}
