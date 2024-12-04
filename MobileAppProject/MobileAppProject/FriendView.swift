// View for friends page
// FriendView.swift
// MobileAppProject
// Carson J. King

import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct FriendView: View {
    
    @EnvironmentObject var friendStore: FriendStore
    @EnvironmentObject var username: Username
    @State private var searchEntry = ""
    @State var addFriend = false
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let lighterGreen = Color(red: 225/255, green: 255/255, blue: 230/255)
    
    
    // function to filter friends based on search
    var searchResults: [String:Int] {
        // Store the friend username and status of the friendship
        var friendList: [String:Int] = [:]
        for friend in friendStore.allFriends {
            friendList[friend.friendUsername] = friend.friendStatus
        }
        if searchEntry.isEmpty {
            return friendList
        } else {
            return friendList.filter({ $0.key.localizedCaseInsensitiveContains(searchEntry)})
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        SearchBarView(searchText: "Search", searchingValue: $searchEntry, action: {})
                        Button(action: { withAnimation(.easeInOut(duration: 0.30)) {addFriend.toggle()} }) {
                            Image(systemName: "person.badge.plus.fill")
                                .font(.title)
                                .padding(.trailing, 35)
                                .padding(.top, 10)
                        }
                        .foregroundStyle(Color.green)
                    }
                    if addFriend {
                        FriendAddView()
                            .frame(height: 250)
                            .transition(.opacity)
                    }
                    List {
                        // Display each friend alphabetically
                        ForEach(searchResults.sorted(by: <), id: \.key) { key, value in
                            NavigationLink {
                                FriendIndividualView(friendUsername: key)
                            } label: {
                                HStack {
                                    VStack {
                                        Spacer()
                                        Text(key)
                                            .font(.title)
                                        Spacer()
                                    }
                                    Spacer()
                                    VStack {
                                        if value == 1 {
                                            Spacer()
                                            Text("Pending")
                                                .font(.title3)
                                                .foregroundStyle(Color.gray)
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
                        DBFriendConnect(username: username.username).callGetFriends(friendStore: friendStore)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

#Preview {
    FriendView()
        .environmentObject(FriendStore())
        .environmentObject(FoundUser())
        .environmentObject(Username())
        .environmentObject(FriendShelvesGlobal())
}
