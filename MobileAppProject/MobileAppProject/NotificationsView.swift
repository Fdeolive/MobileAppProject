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
    
    
    func callUpdateNotifications() {
        Task {
            do {
                await DBNotificationConnect().updateNotfications(notificationStore: notificationStore)
            }
        }
    }
    
    func callDeleteNotification(notification: Notification) {
        Task {
            do {
                await DBNotificationConnect().deleteNotification(notification: notification)
            }
        }
    }
    
    
    
    
    @State var deleteMode = false
    @EnvironmentObject var notificationStore: NotificationStore
    @State private var showingAlert = false
    @State var currentNotification: Notification!
    @State var notificationList = [Notification("New Book Release!", "..."), Notification("John Added to His Wishlist", "..."), Notification("John Added to His Wishlist", "..."), Notification("Daniel Added to His Wishlist", "...")]
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in VStack {
                VStack {
                    HStack {
                        Spacer()
                        Button("Add Notification (Testing)", action: { notificationStore.allNotifications.append(Notification("testineeg", "yesre"))
                            callUpdateNotifications()
                        }).font(.title).padding([.trailing]).foregroundStyle(darkerGreen)
                    }
                    VStack {
                        List {
                            ForEach(notificationStore.allNotifications, id: \.self.notificationId) { notification in
                                NavigationLink { SingleNotificationView(currentNotification: notification)
                                } label: {
                                    VStack {
                                        HStack {
                                            Text(notification.notificationTitle).font(.title2).padding([.leading], 5).padding([.bottom], 15)
                                            Spacer()
                                        }
                                        HStack {
                                            Spacer()
                                            Text("Click to View Notification").foregroundStyle(Color.gray)
                                        }
                                    }
                                }.swipeActions(edge: .leading) { Button("Delete?", action: {showingAlert = true; currentNotification = notification})}.tint(Color.red)
                            }.listRowSeparator(.hidden)
                                .listRowBackground(RoundedRectangle(cornerRadius: 20)
                                    .fill(lighterGreen).overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.green, lineWidth: 2)))
                        }.environment(\.defaultMinListRowHeight, 100).listRowSpacing(10.0).scrollContentBackground(.hidden).alert(currentNotification == nil ? "Delete?" : "Delete \(currentNotification.notificationTitle)?", isPresented: $showingAlert) {
                            Button("Confirm", role: .destructive) {
                                notificationStore.delete(notification: currentNotification)
                                callDeleteNotification(notification: currentNotification)
                            }
                            Button("Cancel", role: .cancel) { }
                        
                        }
                }
            }
            }}
    }.onAppear() {
        //callGetNotifications()
    }
}
}

#Preview {
    NotificationsView().environmentObject(NotificationStore())
}
