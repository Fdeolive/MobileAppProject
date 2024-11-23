// Main view for the notifications page
// NotificationView.swift
// MobileAppProject
// Carson J. King

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct NotificationView: View {
    // Stores notifications in a list/handles persistence
    @EnvironmentObject var notificationStore: NotificationStore
    // For deletion of notifications
    @State private var showingAlert = false
    @State var currentNotification: Notification!
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    func callGetNotifications() {
        Task {
            do {
                await DBNotificationConnect().getNotifications(username: "cking", notificationStore: notificationStore)
            }
        }
    }
    
    // Call async methods from separate file
    func callUpdateNotifications() {
        Task {
            do {
                await DBNotificationConnect().updateNotifications(username: "cking", notificationStore: notificationStore)
            }
        }
    }
    
    func callDeleteNotification(notification: Notification) {
        Task {
            do {
                await DBNotificationConnect().deleteNotification(username: "cking", notification: notification)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in VStack {
                HStack {
                    Spacer()
                    Button("Add Notification (Testing)") {
                        // Update notificationStore
                        notificationStore.allNotifications.append(Notification("dpoulin added to their wishlist", "Harry Potter and the Goblet of Fire was added to dpoulin's wishlist. Go check it out!"))
                        // Update firebase
                        callUpdateNotifications()
                    }
                    .font(.title)
                    .padding([.trailing])
                    .foregroundStyle(darkerGreen)
                }
                VStack {
                    List {
                        // Display each notification
                        ForEach(notificationStore.allNotifications, id: \.self.notificationId) { notification in
                            NavigationLink { NotificationIndividualView(currentNotification: notification)
                            } label: {
                                VStack {
                                    HStack {
                                        Text(notification.notificationTitle)
                                            .font(.title2)
                                            .padding([.leading], 5)
                                            .padding([.bottom], 15)
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Text("Click to View Notification")
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                            }
                            // Swipe to delete mechanic
                            .swipeActions(edge: .leading) { Button("Delete?", action: {showingAlert = true; currentNotification = notification})}
                            .tint(Color.red)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(RoundedRectangle(cornerRadius: 20)
                            .fill(lighterGreen)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)))
                    }
                    .refreshable {
                        callGetNotifications()
                    }
                    .environment(\.defaultMinListRowHeight, 100)
                    .listRowSpacing(10.0)
                    .scrollContentBackground(.hidden)
                    .alert(currentNotification == nil ? "Delete?" : "Delete \(currentNotification.notificationTitle)?", isPresented: $showingAlert) {
                        Button("Confirm", role: .destructive) {
                            // Update notificationStore
                            notificationStore.delete(notification: currentNotification)
                            // Update Firebase
                            callDeleteNotification(notification: currentNotification)
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
            }
        }
    }
}

#Preview {
    NotificationView().environmentObject(NotificationStore())
}
