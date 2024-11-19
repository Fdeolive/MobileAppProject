// Root View for app
// RootView.swift
// MobileAppProject
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var notificationStore: NotificationStore
    @EnvironmentObject var friendStore: FriendStore
    // For persistence
    @Environment(\.scenePhase) var scenePhase
    @State private var startFlag = false
    @State var loadingData = false
    
    // Function to read in all Firebase notifications on start up
    // Can also be used to retrieve other data like friends/shelves/etc
    // Feel free to add another await to do this
    func connectDB() {
        Task {
            do {
                await DBNotificationConnect().getNotifications(notificationStore: notificationStore)
                await DBFriendConnect().getFriends(friendStore: friendStore)
            }
        }
    }
    
    var body: some View {
        VStack() {
            if startFlag {
                HomeView()
            } else {
                // StartView(startFlag: $startFlag)
                //ContentView()
                Button("click to start", action: {startFlag.toggle()})
            }
        }.onChange(of: startFlag) { newStartFlag in
            if newStartFlag {
                connectDB()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("HomeView is active")
            } else if newPhase == .inactive {
                notificationStore.saveChanges()
                friendStore.saveChanges()
                print("HomeView is inactive")
            } else if newPhase == .background {
                print("HomeView is background")
            }
        }
    }
}

#Preview {
    RootView().environmentObject(NotificationStore()).environmentObject(FriendStore())
}
