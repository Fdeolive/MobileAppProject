//
//  NotificationsView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/29/24.
//

import SwiftUI

struct NotificationsView: View {
    
    @EnvironmentObject var currentNotification: Notification
    
    @State var notificationList = [Notification("New Book Release!", "...", 0), Notification("Stacy Added to Her Wishlist", "...", 1), Notification("John Added to His Wishlist", "...", 2), Notification("John Added to His Wishlist", "...", 3), Notification("Daniel Added to His Wishlist", "...", 4)]
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    var body: some View {
        GeometryReader { geometry in VStack {
            Group() {
                if currentNotification.notificationId != -1 {
                    SingleNotificationView()
                } else {
            HStack {
                Spacer()
                Button("Edit", action: { }).font(.title).padding([.trailing]).foregroundStyle(darkerGreen)
            }
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(notificationList, id: \.self.notificationId) { notification in
                                VStack {
                                    HStack {
                                        Text(notification.notificationTitle).font(.title2).padding([.leading], 25).padding([.bottom], 15).padding([.top])
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        Button("Click to View Notification", action: { currentNotification.setNotification(notification)
                                            }).padding([.trailing], 25).foregroundStyle(Color.gray)
                                    }
                                }.frame(width: geometry.size.width - 25, height: geometry.size.height / 6)
                                    .background(lighterGreen).cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 2))
                                    .padding(5)
                            }
                        }
                    }
                }
            }
        }}
    }
}

#Preview {
    NotificationsView().environmentObject(Notification("NA", "NA", -1))
}
