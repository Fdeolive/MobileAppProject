// Object to represent a friend
// Friend.swift
// MobileAppProject
// Carson J. King

import SwiftUICore
import SwiftUI

class Friend: Identifiable, Codable {
    
    var friendUsername = ""
    var friendStatus = 0
    // Auto generated unique ID for notification
    var friendId: UUID
    
    init(_ friendUsername: String, _ friendStatus: Int) {
        self.friendUsername = friendUsername
        self.friendStatus = friendStatus
        self.friendId = UUID()
        
    }
}
