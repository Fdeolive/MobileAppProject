//
//  FriendsView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct FriendsView: View {
    
    
    
    func callGetFriends() {
        Task {
            do {
                await getFriends()
            }
        }
    }
    
    let db = Firestore.firestore()

    func getFriends() async {
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let friends = document.get("friends") as? [String] {
                for friend in friends {
                    friendsList.append(friend)
                }
            } else {
                print("nope")
            }
        } catch {
            print("error getting doc")
        }
    }
    
    @State var searchingFor = ""
    @State var friendsList: [String] = ["dpoulin", "username"]
    
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    var body: some View {
        GeometryReader { geometry in VStack {
            VStack {
                SearchBarView(searchText: "Search Friends", searchingValue: $searchingFor, action: { })
            }
            VStack {
                ForEach(friendsList, id: \.self) { friendId in
                    VStack {
                        Button(friendId, action: {  })
                    }.frame(width: geometry.size.width - 25, height: geometry.size.height / 7.5)
                        .background(lightGreen).cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 2))
                        .padding(5)
                }
            }
        }
        }
    }
}

#Preview {
    FriendsView()
}
