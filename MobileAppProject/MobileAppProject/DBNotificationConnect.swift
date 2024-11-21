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
    
    // Function to read all notifications from Firebase into the NotificationStore
    // NOTE: Only reads in notifications that the NotificationStore doesn't already have
    func getNotifications(notificationStore: NotificationStore) async {
        DispatchQueue.main.async {
            for notification in notificationStore.allNotifications {
                notificationStore.delete(notification: notification)
            }
        }
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                for (id, value) in notifications {
                    DispatchQueue.main.async {
                        notificationStore.allNotifications.append(Notification(value["notificationTitle"]!, value["notificationSummary"]!))
                    }
                }
            } else {
                print("Nope")
            }
            print("Docs recieved")
        } catch {
            print("Error retrieving document")
        }
    }
    
    // Function for updating/adding notifications to Firebase
    func updateNotifications(notificationStore: NotificationStore) async {
        for notification in notificationStore.allNotifications {
            do {
                try await db.collection("user").document("cking").updateData(["notifications.\(notification.notificationId).notificationTitle": notification.notificationTitle,"notifications.\(notification.notificationId).notificationSummary": notification.notificationSummary])
                print("Document updated successfully")
            } catch {
                print("Error updating document")
            }
        }
    }
    
    // Function for deleting notifications from Firebase
    func deleteNotification(notification: Notification) async {
        do {
            try await db.collection("user").document("cking").updateData(["notifications.\(notification.notificationId)": FieldValue.delete()])
            print("Document deleted successfully")
        } catch {
            print("Error deleting document")
        }
    }
}
