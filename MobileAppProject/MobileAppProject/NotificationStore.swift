// Class for storing notifications and for reading from the device
// NotificationStore.swift
// MobileAppProject
// Carson J. King

import Foundation

class NotificationStore: ObservableObject {
    @Published var allNotifications: [Notification]
    // Setting to true turns on loading persisted data
    // NOTE: Will cause preview to crash/only works in simulator
    // Reset to false to play around in preview!
    
    // Path to json file
    
    // Load saved data if loadFromFile
    // Else load no data and start with empty list of notifications
    init() {
        allNotifications = []
    }
    
    // Function to delete notifications from the NotificationStore
    func delete(notification: Notification!) {
        if let idx = allNotifications.firstIndex(where: {$0.notificationId == notification.notificationId}) {
            allNotifications.remove(at: idx)
        }
    }
    
}
