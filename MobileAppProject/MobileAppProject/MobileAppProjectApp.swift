//
//  MobileAppProjectApp.swift
//  MobileAppProject
//
//  Created by user267577 on 10/17/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
//import GoogleSignIn//

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Configured Firebase!")

    return true
  }
}

@main
struct MobileAppProjectApp: App {
    // Register app deligate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
