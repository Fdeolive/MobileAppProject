//
//  RootView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/17/24.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var notificationStore: NotificationStore
    @Environment(\.scenePhase) var scenePhase
    @State private var startFlag = true
    var body: some View {
        VStack() {
            if startFlag {
                HomeView()
            } else {
                // StartView(startFlag: $startFlag)
                ContentView()
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                print("HomeView is active")
            } else if newScenePhase == .inactive {
                notificationStore.saveChanges()
                print("HomeView is inactive")
            } else if newScenePhase == .background {
                print("HomeView is background")
            }
        }
    }
}

#Preview {
    RootView()
}
