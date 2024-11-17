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
    @State private var startFlag = false
    var body: some View {
        VStack() {
            if startFlag {
                HomeView()
            } else {
                // StartView(startFlag: $startFlag)
                //ContentView()
                Button("click to start", action: {startFlag.toggle()})
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
    RootView()
}
