//
//  SingleNotificationView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/5/24.
//

import SwiftUI

struct SingleNotificationView: View {
    
    private let lighterGreen = Color(red: 220/255, green: 255/255, blue: 220/255)
    @EnvironmentObject var currentNotification: Notification
    
    
    var body: some View {
        GeometryReader { geometry in VStack {
            VStack {
                HStack {
                    Spacer()
                    Button("", systemImage: "clear", action: { currentNotification.notificationId = -1 }).foregroundColor(Color.black).font(.title)
                }.padding(25)
                HStack {
                    Text(currentNotification.notificationTitle).font(.title)
                    Spacer()
                }.padding([.leading],25)
                
                HStack {
                    Text(currentNotification.notifcationSummary)
                    Spacer()
                }.padding([.leading], 25).padding([.top], 10)
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height).background(lighterGreen)
            
        }
        }
    }
}

#Preview {
    SingleNotificationView().environmentObject(Notification("NA", "NA", -1))
}
