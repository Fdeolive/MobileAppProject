//
//  Username.swift
//  MobileAppProject
//
//  Created by user267577 on 11/26/24.
//

import Foundation

class Username: ObservableObject {
    @Published var username: String
    
    init() {
        username = "default"
    }
}
