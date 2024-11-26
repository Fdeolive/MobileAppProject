//
//  MobileAppProjectApp.swift
//  MobileAppProject
//
//  Created by user267577 on 10/17/24.
//
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

// AppDelegate class to handle app lifecycle events
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

@main
struct MobileAppProjectApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Loggedin state
    @State private var isLoggedIn = false
    @State private var user: User?

    // Initialize Firebase
    init() {
        FirebaseApp.configure()
        print("Firebase Initialized!")
                
        // Check if the user is currently logged in
        if let currentUser = Auth.auth().currentUser {
            self.isLoggedIn = true
            // Store logged in user
            self.user = currentUser
        }
    }

    var body: some Scene {
        // Views based on login status
        WindowGroup {
            // Display HomeView if user has logged in before, otherwise go to login page
            if isLoggedIn {
                RootView().environmentObject(NotificationStore())
                    .environmentObject(FriendStore())
                    .environmentObject(FoundUser())
                    .environmentObject(Loading())
                    .environmentObject(Username())
            } else {
                ContentView().environmentObject(NotificationStore())
                    .environmentObject(FriendStore())
                    .environmentObject(FoundUser())
                    .environmentObject(Loading())
                    .environmentObject(Username())
            }
        }
    }
}
