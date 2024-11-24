// Root View for app
// RootView.swift
// MobileAppProject
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct RootView: View {
    
    // App users notifications and friends
    @EnvironmentObject var notificationStore: NotificationStore
    @EnvironmentObject var friendStore: FriendStore
    // Object to know whether the loading of data for the app is done or not
    @EnvironmentObject var loading: Loading
    // For persistence
    @Environment(\.scenePhase) var scenePhase
    @State private var startFlag = false
    @State var loadingData = false
    var user: User?
    
    
    // Function to connect DB and load data for the app
    func connectDB() {
        Task {
            do {
                await DBNotificationConnect(username: "cking").getNotifications(notificationStore: notificationStore)
                await DBFriendConnect(username: "cking").getFriends(friendStore: friendStore)
                // Await functions are done so loading is false
                loading.isLoading = false
            }
        }
    }
    
    var body: some View {
        VStack() {
            // Bridge gap between login/register and HomeView of app
            if loading.isLoading == false {
                HomeView()
            } else {
                LoadingView()
            }
        }
        .onAppear() {
            connectDB()
        }
        .onChange(of: scenePhase) { newPhase in
            // For persistence
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
    RootView()
        .environmentObject(NotificationStore())
        .environmentObject(FriendStore())
        .environmentObject(FoundUser())
        .environmentObject(Loading())
}
