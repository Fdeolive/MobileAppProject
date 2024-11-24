// Struct for connections to firebase regarding Notifications
// DBNotificationConnect.swift
// MobileAppProject
// Carson J. King

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBNotificationConnect {
    
    // Get db
    let db = Firestore.firestore()
    private var username = ""
    
    init(username: String) {
        self.username = username
    }
    
    // Call async methods
    func callGetNotifications(notificationStore: NotificationStore) {
        Task {
            do {
                await getNotifications(notificationStore: notificationStore)
            }
        }
    }
    
    func callUpdateNotifications(notificationStore: NotificationStore) {
        Task {
            do {
                await updateNotifications(notificationStore: notificationStore)
            }
        }
    }
    
    func callDeleteNotification(notification: Notification) {
        Task {
            do {
                await deleteNotification(notification: notification)
            }
        }
    }
    
    func callDeleteAllNotifications() {
        Task {
            do {
                await deleteAllNotifications()
            }
        }
    }
    
    // Function to read all notifications from Firebase into the NotificationStore
    func getNotifications(notificationStore: NotificationStore) async {
        DispatchQueue.main.async {
            notificationStore.allNotifications = []
        }
        let docRef = db.collection("user").document("\(username)")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                for (id, value) in notifications {
                    DispatchQueue.main.async {
                        notificationStore.allNotifications.append(Notification(value["notificationTitle"]!, value["notificationSummary"]!, UUID(uuidString: id)!))
                    }
                }
            } else {
                print("Nil found")
            }
            print("Documents recieved")
        } catch {
            print("Error retrieving document")
        }
    }
    
    // Function for updating/adding notifications to Firebase
    func updateNotifications(notificationStore: NotificationStore) async {
        let docRef = db.collection("user").document("\(username)")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                for notification in notificationStore.allNotifications {
                    var alreadyInDatabase = false
                    for (id, value) in notifications {
                        if notification.notificationId == UUID(uuidString: id) {
                            alreadyInDatabase = true
                        }
                    }
                    // Only add notifications not already in db
                    if alreadyInDatabase == false {
                        try await db.collection("user").document("\(username)").updateData(["notifications.\(notification.notificationId).notificationTitle": notification.notificationTitle,"notifications.\(notification.notificationId).notificationSummary": notification.notificationSummary])
                        print("Document updated successfully")
                    }
                }
            } else {
                print("Nil found")
            }
            print("Documents recieved")
        } catch {
            print("Error retrieving document")
        }
    }
    
    // Function for deleting notifications from Firebase
    func deleteNotification(notification: Notification) async {
        do {
            try await db.collection("user").document("\(username)").updateData(["notifications.\(notification.notificationId)": FieldValue.delete()])
            print("Notification deleted successfully")
        } catch {
            print("Error deleting notification")
        }
    }
    
    func deleteAllNotifications() async {
        do {
            try await db.collection("user").document("\(username)").updateData(["notifications": FieldValue.delete()])
            print("All notifications deleted successfully")
        } catch {
            print("Error deleting all notifications")
        }
    }
}
