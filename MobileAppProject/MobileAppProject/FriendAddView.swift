// View for adding a friend
// FriendAddView.swift
// MobileAppProject
// Carson J. King

import SwiftUI

struct FriendAddView: View {
    
    @EnvironmentObject var friendStore: FriendStore
    @State private var searchEntry = ""
    @State var userExists = false
    @State var findUser = ""
    private let lighterGreen = Color(red: 225/255, green: 255/255, blue: 230/255)
    @EnvironmentObject var foundUser: FoundUser
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                HStack {
                    SearchBarView(searchText: "Find for a friend", searchingValue: $searchEntry, action: {})
                    Button("Find") {
                        findUser = searchEntry
                        DBFriendConnect(username: "cking").callFindUserToFriend(friendStore: friendStore, foundUser: foundUser, friendSearch: findUser) }
                    .foregroundStyle(Color.green)
                    .font(.title3)
                    .bold()
                    .padding(5)
                    .background(lighterGreen)
                    .overlay(Rectangle()
                        .stroke(Color.green, lineWidth: 2)).padding(.trailing, 20)
                }
                if foundUser.userStatus == 2 && findUser != "" {
                    Text("User found").padding(.top).bold()
                    List {
                        VStack {
                            NavigationLink {
                                FriendIndividualView(friendUsername: foundUser.username)
                            } label: {
                                Text(foundUser.username)
                                    .font(.title)
                            }
                        }
                        .padding()
                        .background(lighterGreen)
                        .listRowSeparatorTint(Color.green)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    Spacer()
                } else if foundUser.userStatus == 3 && searchEntry != "" && findUser != "" {
                    Text("You are already friends with \(foundUser.username)")
                        .padding(.top)
                        .bold()
                    Spacer()
                } else if foundUser.userStatus == 1 && searchEntry != "" && findUser != "" {
                    Text("The user you are searching for does not exist")
                        .padding(.top)
                        .bold()
                    Spacer()
                } else {
                    Text("Search for a friend to add")
                        .padding(.top)
                        .bold()
                    Spacer()
                }
            }
            .frame(height: 225)
            .padding(10)
            .background(Color.white)
            .clipped()
            .cornerRadius(5)
            .padding(5)
            .shadow(color: Color.black, radius: 3)
            
        }
    }
}

#Preview {
    FriendAddView()
        .environmentObject(FriendStore())
        .environmentObject(FoundUser())
}
