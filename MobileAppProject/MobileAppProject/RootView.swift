// Root View for app
// RootView.swift
// MobileAppProject
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct RootView: View {
    
    // App users notifications and friends
    @EnvironmentObject var notificationStore: NotificationStore
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var username: Username
    // Object to know whether the loading of data for the app is done or not
    @EnvironmentObject var loading: Loading
    // For persistence
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var shelvesGlobal: ShelvesGlobal
    @State private var startFlag = false
    @State var loadingData = false

    
    
    
    // Function to connect DB and load data for the app
    func connectDB() {
        Task {
            do {
                await getUserName(username: username)
                await DBNotificationConnect(username: username.username).getNotifications(notificationStore: notificationStore)
                await DBFriendConnect(username: username.username).getFriends(friendStore: friendStore)
                await DBShelvesConnect(username: username.username).getShelves(shelvesGlobal: shelvesGlobal)
                await DBShelvesConnect(username: username.username).fillShelves(shelvesGlobal: shelvesGlobal)
                // Await functions are done so loading is false
                loading.isLoading = false
            }
        }
    }
    
    func getUserName(username: Username) async {
        let db = Firestore.firestore()
        var userId = ""
        do {
            if Auth.auth().currentUser != nil {
                userId = Auth.auth().currentUser!.uid
                let docs = try await db.collection("user").whereField("uid", isEqualTo: userId).getDocuments()
                for doc in docs.documents {
                    username.username = doc.get("username") as! String
                    print(1)
                }
            } else {
                    username.username = "default"
            }
            print(3)
            print(username.username)
        } catch {
            print("Error getting username")
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
            print(2)
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
        .environmentObject(Username())
        .environmentObject(ShelvesGlobal())
}
