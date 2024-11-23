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
    private let lighterGreen = Color(red: 225/255, green: 255/255, blue: 230/255)
    
    func getFriends() {
        Task {
            do {
                await DBFriendConnect().getFriends(username: "cking", friendStore: friendStore)
            }
        }
    }
    
    // Function to  filter friendsList
    // NOTE: From the internet!
    var searchResults: [String:Int] {
        var friendList: [String:Int] = [:]
        for friend in friendStore.allFriends {
            friendList[friend.friendUsername] = friend.friendStatus
        }
        if searchText.isEmpty {
            return friendList
        } else {
            return friendList.filter({ $0.key.localizedCaseInsensitiveContains(searchText)})
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
                        ForEach(searchResults.sorted(by: <), id: \.key) { key, value in
                            NavigationLink {
                                FriendIndividualView(friendUsername: key)
                            } label: {
                                HStack {
                                    VStack {
                                        Spacer()
                                        Text(key).font(.title)
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack {
                                        if value == 1 {
                                            Spacer()
                                            Text("Pending").font(.title3).foregroundStyle(Color.gray)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(lighterGreen)
                        .listRowSeparatorTint(Color.green)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .refreshable {
                        getFriends()
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

#Preview {
    FriendView().environmentObject(FriendStore()).environmentObject(FoundUser())
}
