// View for a single notification
// NotificationIndividualView.swift
// MobileAppProject
// Carson J. King

import SwiftUI

struct NotificationIndividualView: View {
    
    @State var currentNotification: Notification
    @State private var showProfile = false
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    private let lightishGreen = Color(red: 140/255, green: 255/255, blue: 200/255)
    
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
            // If notification has a friendsUsername display that
            if currentNotification.friendUsername != "" {
                HStack {
                    List {
                        VStack {
                            NavigationLink {
                                FriendIndividualView(friendUsername: currentNotification.friendUsername)
                            } label: {
                                Text(currentNotification.friendUsername)
                                    .font(.title)
                            }
                        }
                        .padding()
                        .background(lightishGreen)
                        .listRowSeparatorTint(Color.green)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .background(lighterGreen)
        }}
}

#Preview {
    NotificationIndividualView(currentNotification: Notification("dpoulin added to their wishlist", "Harry Potter and the Goblet of Fire was added to dpoulin's wishlist!", UUID(), "dpoulin"))
}
