// Main view for the notifications page
// NotificationView.swift
// MobileAppProject
// Carson J. King

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct NotificationView: View {
    var user: User?
    
    @EnvironmentObject var notificationStore: NotificationStore
    @EnvironmentObject var username: Username
    // Alert for deleting notifications
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    @State var currentNotification: Notification!
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    @State var showDeleteAll = false
    
    var body: some View {
        NavigationView {
            GeometryReader {geometry in VStack {
                HStack {
                    if showDeleteAll {
                        //TODO: Delete
                        Button("add") {
                            notificationStore.allNotifications.append(Notification("dpoulin added to their wishlist!", "Harry Potter and the Goblet of Fire was added to dpoulin's wishlist. Go check it out!"))
                            DBNotificationConnect(username: username.username).callUpdateNotifications(notificationStore: notificationStore)
                        }.font(.title)
                        Button("Delete All") {
                            showingAlert2 = true
                        }
                        .transition(.slide)
                        .font(.title)
                        .padding([.leading])
                        .foregroundStyle(darkerGreen)
                    }
                    Spacer()
                    Button("Edit") {withAnimation(.easeInOut(duration: 0.30)) { showDeleteAll.toggle()
                    }}
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
                            .swipeActions(edge: .leading) { Button("Delete?", action: {showingAlert1 = true; currentNotification = notification})}
                            .tint(Color.red)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(RoundedRectangle(cornerRadius: 20)
                            .fill(lighterGreen)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)))
                    }
                    .refreshable {
                        DBNotificationConnect(username: username.username).callGetNotifications(notificationStore: notificationStore)
                        print(username.username)
                    }
                    .environment(\.defaultMinListRowHeight, 100)
                    .listRowSpacing(10.0)
                    .scrollContentBackground(.hidden)
                    .alert(currentNotification == nil ? "Delete?" : "Delete \(currentNotification.notificationTitle)?", isPresented: $showingAlert1) {
                        Button("Confirm", role: .destructive) {
                            // Update notificationStore
                            notificationStore.delete(notification: currentNotification)
                            // Update Firebase
                            DBNotificationConnect(username: username.username).callDeleteNotification(notification: currentNotification)
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    .alert("Delete all notifications?", isPresented: $showingAlert2) {
                        Button("Confirm", role: .destructive) {
                            // Update notificationStore
                            // Update Firebase
                            DBNotificationConnect(username: username.username).callDeleteAllNotifications(notificationStore: notificationStore)
                            notificationStore.deleteAll()
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
    NotificationView()
        .environmentObject(NotificationStore())
        .environmentObject(Username())
}
