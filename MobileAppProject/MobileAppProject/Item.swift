//
//  Item.swift
//  MobileAppProject
//
//  Created by user264318 on 11/19/24.
//

import Foundation
import SwiftUI
import SwiftData

class Item: ObservableObject {
    @Published var image: Data? {
        didSet {
            saveImageToUserDefaults() // Save whenever image changes
        }
    }
    
    private let imageKey = "profileImageKey"
    
    init() {
        loadImageFromUserDefaults() // Load the image when Item is initialized
    }
    
    // Save the image to UserDefaults
    private func saveImageToUserDefaults() {
        if let imageData = image {
            UserDefaults.standard.set(imageData, forKey: imageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: imageKey)
        }
    }
    
    // Load the image from UserDefaults
    private func loadImageFromUserDefaults() {
        if let imageData = UserDefaults.standard.data(forKey: imageKey) {
            self.image = imageData
        }
    }
}



