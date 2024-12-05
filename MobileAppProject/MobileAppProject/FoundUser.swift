// A class to track a found user
// FriendExists.swift
// MobileAppProject
// Carson J. King

import Foundation

class FoundUser: ObservableObject {
    @Published var userStatus = 0
    @Published var username = ""
    @Published var bio = ""
    
    init() {
        self.userStatus = 0
        self.username = ""
        self.bio = ""
    }
}


