//
//  NotificationsView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/29/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct NotificationsView: View {
    
    
    func callGetNotifications() {
        Task {
            do {
                await getNotifications()
            }
        }
    }
    
    let db = Firestore.firestore()
    
    func getNotifications() async {
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                notificationStore.allNotifications.removeAll()
                for (id, value) in notifications {
                    notificationStore.allNotifications.append(Notification(value["notificationTitle"]!, value["notificationSummary"]!))
                }
            } else {
                print("nope")
            }
        } catch {
            print("error getting doc")
        }
    }
    
    
    
    @State var deleteMode = false
    @EnvironmentObject var notificationStore: NotificationStore
    @State var notificationList = [Notification("New Book Release!", "..."), Notification("John Added to His Wishlist", "..."), Notification("John Added to His Wishlist", "..."), Notification("Daniel Added to His Wishlist", "...")]
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in VStack {
                VStack {
                        HStack {
                            Spacer()
                            Button("Edit", action: { callGetNotifications() }).font(.title).padding([.trailing]).foregroundStyle(darkerGreen)
                        }
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(notificationStore.allNotifications, id: \.self.notificationId) { notification in
                                    NotificationView(notification: notification)
                                }
                            }
                        }
                }
            }}
        }
    }
}

#Preview {
    NotificationsView().environmentObject(NotificationStore())
}
