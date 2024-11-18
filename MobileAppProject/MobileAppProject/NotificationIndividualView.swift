// View for a single notification
// NotificationIndividualView.swift
// MobileAppProject
// Carson J. King

import SwiftUI

struct NotificationIndividualView: View {
    
    @State var currentNotification: Notification
    private let lighterGreen = Color(red: 220/255, green: 255/255, blue: 220/255)
    
    var body: some View {
        GeometryReader { geometry in VStack {
            // Display title
            HStack {
                Text(currentNotification.notificationTitle).font(.title)
                Spacer()
            }
            .padding([.leading], 25)
            .padding(15)
            // Display summary
            HStack {
                Text(currentNotification.notificationSummary)
                Spacer()
            }
            .padding([.leading], 40)
            .padding(15)
            Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .background(lighterGreen)
        }
    }
}

#Preview {
    NotificationIndividualView(currentNotification: Notification("NA", "NA"))
}
