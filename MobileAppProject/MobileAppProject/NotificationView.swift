//
//  NotificationView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/17/24.
//

import SwiftUI

struct NotificationView: View {
    @State var notification = Notification("NA", "NA")
    @State private var showNotification = false
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    
    var body: some View {
        VStack {
            HStack {
                Text(notification.notificationTitle).font(.title2).padding([.leading], 25).padding([.bottom], 15)
                Spacer()
            }
            HStack {
                Spacer()
                Button("Click to View Notification", action: { showNotification.toggle()
                }).padding([.trailing], 25).foregroundStyle(Color.gray)
            }.navigationDestination(isPresented: $showNotification) { SingleNotificationView(currentNotification: notification) }
        }.frame(width: 300, height: 100)
            .background(lighterGreen).cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 2))
            .padding(5)
    }
}

#Preview {
    NotificationView()
}
