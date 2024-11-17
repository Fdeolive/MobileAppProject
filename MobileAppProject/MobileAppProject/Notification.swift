//
//  Notification.swift
//  MobileAppProject
//
//  Created by user267577 on 10/29/24.
//

import SwiftUICore
import SwiftUI

class Notification: Identifiable, Codable {
    
    var notificationTitle = ""
    var notificationSummary = ""
    var notificationId: UUID
    
    init(_ notificationTitle: String, _ notificationSummary: String) {
        self.notificationTitle = notificationTitle
        self.notificationSummary = notificationSummary
        self.notificationId = UUID()
        
    }
    
    func setNotification(_ notification: Notification) {
        self.notificationTitle = notification.notificationTitle
        self.notificationSummary = notification.notificationSummary
        self.notificationId = notification.notificationId
    }
}
