// Notification Object
// Notification.swift
// MobileAppProject
// Carson J. King

import SwiftUICore
import SwiftUI

class Notification: Identifiable, Codable {
    
    var notificationTitle = ""
    var notificationSummary = ""
    // Auto generated unique ID for notification
    var notificationId: UUID
    
    init(_ notificationTitle: String, _ notificationSummary: String) {
        self.notificationTitle = notificationTitle
        self.notificationSummary = notificationSummary
        self.notificationId = UUID()
        
    }
}
