//
//  SingleNotificationView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/5/24.
//

import SwiftUI

struct SingleNotificationView: View {
    
    private let lighterGreen = Color(red: 220/255, green: 255/255, blue: 220/255)
    @State var currentNotification: Notification
    
    
    var body: some View {
        GeometryReader { geometry in VStack {
            VStack {
                HStack {
                    Text(currentNotification.notificationTitle).font(.title)
                    Spacer()
                }.padding([.leading],25)
                
                HStack {
                    Text(currentNotification.notificationSummary)
                    Spacer()
                }.padding([.leading], 25).padding([.top], 10)
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height).background(lighterGreen)
            
        }
        }
    }
}

#Preview {
    SingleNotificationView(currentNotification: Notification("NA", "NA"))
}
