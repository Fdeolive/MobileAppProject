// Root View for app
// RootView.swift
// MobileAppProject
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var notificationStore: NotificationStore
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var loading: Loading
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
                await DBNotificationConnect().getNotifications(username: "cking", notificationStore: notificationStore)
                await DBFriendConnect().getFriends(username: "cking", friendStore: friendStore)
                loading.isLoading = false
            }
        }
    }
    
    var body: some View {
        VStack() {
            if startFlag {
                if loading.isLoading == false {
                    HomeView()
                } else {
                    LoadingView()
                }
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
                print("HomeView is inactive")
            } else if newPhase == .background {
                print("HomeView is background")
            }
        }
    }
}

#Preview {
    RootView().environmentObject(NotificationStore()).environmentObject(FriendStore())
        .environmentObject(FoundUser()).environmentObject(Loading())
}
