//
//  Notification.swift
//  MobileAppProject
//
//  Created by user267577 on 10/29/24.
//

import SwiftUICore
import SwiftUI

class Notification: ObservableObject {
    
    @Published var notificationTitle = ""
    @Published var notificationSummary = ""
    @Published var notificationId = 0
    
    init(_ notificationTitle: String, _ notificationSummary: String, _ notificationId: Int) {
        self.notificationTitle = notificationTitle
        self.notificationSummary = notificationSummary
        self.notificationId = notificationId
        
    }
    
    func setNotification(_ notification: Notification) {
        self.notificationTitle = notification.notificationTitle
        self.notificationSummary = notification.notificationSummary
        self.notificationId = notification.notificationId
    }
}
