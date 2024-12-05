// Object to represent a friend
// Friend.swift
// MobileAppProject
// Carson J. King

import SwiftUICore
import SwiftUI

class Friend: Identifiable, Codable {
    
    var friendUsername = ""
    var friendStatus = 0
    var friendBio = ""
    // Auto generated unique ID for notification
    var friendId: UUID
    
    init(_ friendUsername: String, _ friendStatus: Int, _ friendBio: String) {
        self.friendUsername = friendUsername
        self.friendBio = friendBio
        self.friendStatus = friendStatus
        self.friendId = UUID()
        
    }
}
