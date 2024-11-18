//
//  dbNotificationCalls.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBNotificationConnect {
    
    let db = Firestore.firestore()
    
    func getNotifications(notificationStore: NotificationStore) async {
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                for (id, value) in notifications {
                    var alreadyInStore = false
                    for notification in notificationStore.allNotifications {
                        if "\(notification.notificationId)" == id {
                            alreadyInStore = true
                        }
                    }
                    if alreadyInStore == false {
                        notificationStore.allNotifications.append(Notification(value["notificationTitle"]!, value["notificationSummary"]!))
                    }
                    }
                } else {
                print("nope")
            }
        } catch {
            print("error getting doc")
        }
    }
    
    func updateNotfications(notificationStore: NotificationStore) async {
        for notification in notificationStore.allNotifications {
            do {
                try await db.collection("user").document("cking").updateData(["notifications.\(notification.notificationId).notificationTitle": notification.notificationTitle,"notifications.\(notification.notificationId).notificationSummary": notification.notificationSummary])
                print("Doc updated successfully")
            } catch {
                print("Error Updating Doc")
            }
        }
    }
    
    func deleteNotification(notification: Notification) async {
        do {
            try await db.collection("user").document("cking").updateData(["notifications.\(notification.notificationId)": FieldValue.delete()])
            print("Doc deleted successfully")
        } catch {
            print("Error deleting Doc")
        }
    }
}
