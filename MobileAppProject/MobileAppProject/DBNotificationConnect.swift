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
    func getNotifications(username: String, notificationStore: NotificationStore) async {
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
                print("Nope")
            }
            print("Docs recieved")
        } catch {
            print("Error retrieving document")
        }
    }
    
    // Function for updating/adding notifications to Firebase
    func updateNotifications(username: String, notificationStore: NotificationStore) async {
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
                    if alreadyInDatabase == false {
                        try await db.collection("user").document("\(username)").updateData(["notifications.\(notification.notificationId).notificationTitle": notification.notificationTitle,"notifications.\(notification.notificationId).notificationSummary": notification.notificationSummary])
                        print("Document updated successfully")
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
    
    // Function for deleting notifications from Firebase
    func deleteNotification(username: String, notification: Notification) async {
        do {
            try await db.collection("user").document("\(username)").updateData(["notifications.\(notification.notificationId)": FieldValue.delete()])
            print("Document deleted successfully")
        } catch {
            print("Error deleting document")
        }
    }
}
