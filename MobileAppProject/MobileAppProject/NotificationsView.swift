//
//  NotificationsView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/29/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct NotificationsView: View {
    
    
    func callGetNotifications() {
        Task {
            do {
                await getNotifications()
            }
        }
    }
    
    let db = Firestore.firestore()
    
    func getNotifications() async {
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let notifications = document.get("notifications") as? [String:[String:String]] {
                for (id, value) in notifications {
                    notificationList.append(Notification(value["notificationTitle"]!, value["notificationSummary"]!, Int(id)!))
                }
            } else {
                print("nope")
            }
        } catch {
            print("error getting doc")
        }
    }
    
    
    @EnvironmentObject var currentNotification: Notification
    
    @State var deleteMode = false
    
    @State var notificationList = [Notification("New Book Release!", "...", 0), Notification("John Added to His Wishlist", "...", 5), Notification("John Added to His Wishlist", "...", 2), Notification("Daniel Added to His Wishlist", "...", 3)]
    private let darkerGreen = Color(red: 0/255, green: 150/255, blue: 25/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    var body: some View {
        GeometryReader { geometry in VStack {
            VStack {
                Group() {
                    if currentNotification.notificationId != -1 {
                        SingleNotificationView()
                    } else {
                        HStack {
                            Spacer()
                            Button("Edit", action: { deleteMode.toggle() }).font(.title).padding([.trailing]).foregroundStyle(darkerGreen)
                        }
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(notificationList, id: \.self.notificationId) { notification in
                                    VStack {
                                        HStack {
                                            Spacer()
                                            // TODO: Make better delete
                                            if deleteMode {
                                                Button(action: {}) {
                                                    Image(systemName: "minus.circle").padding([.trailing], 10).font(.title).foregroundStyle(Color.red)
                                                }
                                            }
                                        }
                                        HStack {
                                            Text(notification.notificationTitle).font(.title2).padding([.leading], 25).padding([.bottom], 15)
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
            }
        }}
    }
}

#Preview {
    NotificationsView().environmentObject(Notification("NA", "NA", -1))
}
