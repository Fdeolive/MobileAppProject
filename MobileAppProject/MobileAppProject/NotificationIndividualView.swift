// View for a single notification
// NotificationIndividualView.swift
// MobileAppProject
// Carson J. King

import SwiftUI

struct NotificationIndividualView: View {
    
    @State var currentNotification: Notification
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    var body: some View {
        GeometryReader { geometry in VStack {
            // Display title
            HStack {
                Text(currentNotification.notificationTitle).font(.title).bold()
                Spacer()
            }
            .padding([.leading], 25)
            .padding(15)
            // Display summary
            HStack {
                Text(currentNotification.notificationSummary).font(.title3)
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
    NotificationIndividualView(currentNotification: Notification("dpoulin added to their wishlist", "Harry Potter and the Goblet of Fire was added to dpoulin's wishlist!"))
}
