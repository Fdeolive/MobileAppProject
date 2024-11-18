//
//  RootView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/17/24.
//

import SwiftUI

struct RootView: View {
    
    func connectDB() {
        Task {
            do {
                await DBNotificationConnect().getNotifications(notificationStore: notificationStore)
            }
        }
    }
    
    @EnvironmentObject var notificationStore: NotificationStore
    @Environment(\.scenePhase) var scenePhase
    @State private var startFlag = false
    @State var loadingData = false
    
    
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
                print("HomeView is inactive")
            } else if newPhase == .background {
                print("HomeView is background")
            }
        }
    }
}

#Preview {
    RootView().environmentObject(NotificationStore())
}
