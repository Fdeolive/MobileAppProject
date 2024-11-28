// Object to hold a username from an async call
// Username.swift
// MobileAppProject
// Carson J. King

import Foundation

class Username: ObservableObject {
    @Published var username: String
    
    init() {
        username = "default"
    }
}
