//
//  FriendView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct FriendView: View {
    @EnvironmentObject var friendStore: FriendStore
    @State var friendsList: [String] = ["john", "Joe", "Derrick"]
    @State private var searchText = ""
    @State var addFriend = false
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    // Function to  filter friendsList
    // NOTE: From the internet!
    var searchResults: [String] {
        var friendList: [String] = []
        for friend in friendStore.allFriends {
            friendList.append(friend.friendUsername)
        }
        if searchText.isEmpty {
            return friendList
        } else {
            return friendList.filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        SearchBarView(searchText: "Search", searchingValue: $searchText, action: {})
                        Button(action: { addFriend.toggle()}) {
                            Image(systemName: "person.badge.plus.fill")
                                .font(.title)
                                .padding(.trailing, 35)
                                .padding(.top, 10)
                        }
                        .foregroundStyle(Color.green)
                    }
                    if addFriend {
                        FriendAddView()
                    }
                    List {
                        ForEach(searchResults, id: \.self) { username in
                            NavigationLink {
                                FriendIndividualView(friendUsername: username)
                            } label: {
                                Text(username)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(RoundedRectangle(cornerRadius: 20)
                            .fill(lighterGreen)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)))
                    }
                    .environment(\.defaultMinListRowHeight, 100)
                    .listRowSpacing(10.0)
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

#Preview {
    FriendView().environmentObject(FriendStore()).environmentObject(FoundUser())
}
