//
//  Friend.swift
//  MobileAppProject
//
//  Created by user267577 on 11/19/24.
//

import SwiftUICore
import SwiftUI

class Friend: Identifiable, Codable {
    
    var friendUsername = ""
    // Auto generated unique ID for notification
    var friendId: UUID
    
    init(_ friendUsername: String) {
        self.friendUsername = friendUsername
        self.friendId = UUID()
        
    }
}
