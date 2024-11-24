// Class for storing notifications
// NotificationStore.swift
// MobileAppProject
// Carson J. King

import Foundation

class NotificationStore: ObservableObject {
    @Published var allNotifications: [Notification]
    
    init() {
        allNotifications = []
    }
    
    // Function to delete notifications from the NotificationStore
    func delete(notification: Notification!) {
        if let idx = allNotifications.firstIndex(where: {$0.notificationId == notification.notificationId}) {
            allNotifications.remove(at: idx)
        }
    }
    
    // Function to delete all notifications
    func deleteAll() {
        allNotifications = []
    }
}
