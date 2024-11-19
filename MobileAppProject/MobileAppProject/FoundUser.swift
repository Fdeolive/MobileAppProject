//
//  FriendExists.swift
//  MobileAppProject
//
//  Created by user267577 on 11/19/24.
//

import Foundation

class FoundUser: ObservableObject {
    @Published var userStatus = 0
    @Published var username = ""
    
    init() {
        self.userStatus = 0
        self.username = ""
    }
}


