//
//  FriendAddView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import SwiftUI

struct FriendAddView: View {
    
    @EnvironmentObject var friendStore: FriendStore
    @State private var searchText = ""
    @State var userExists = false
    @State var findUser = ""
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    @EnvironmentObject var foundUser: FoundUser
    
    func calladdFriend() {
        Task {
            do {
                await DBFriendConnect().findUserToFriend(friendStore: friendStore, foundUser: foundUser, friendSearch: searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBarView(searchText: "Find for a friend", searchingValue: $searchText, action: {})
                    Button("Find") {
                        findUser = searchText
                        calladdFriend() }
                    .foregroundStyle(Color.green)
                    .font(.title3)
                    .bold()
                    .padding(5)
                    .background(lighterGreen)
                    .overlay(Rectangle()
                        .stroke(Color.green, lineWidth: 2)).padding(.trailing, 20)
                }
                if foundUser.userStatus == 2 && findUser != "" {
                    Text("User found")
                    List {
                        VStack {
                            NavigationLink {
                                FriendIndividualView()
                            } label: {
                                Text(foundUser.username)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(RoundedRectangle(cornerRadius: 20)
                            .fill(lighterGreen)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 2)))
                    }
                    .scrollDisabled(true)
                    .environment(\.defaultMinListRowHeight, 100)
                    .scrollContentBackground(.hidden)
                    Spacer()
                } else if foundUser.userStatus == 3 && searchText != "" && findUser != "" {
                    Text("You are already friends with \(foundUser.username)")
                    Spacer()
                } else if foundUser.userStatus == 1 && searchText != "" && findUser != "" {
                    Text("The user you are searching for does not exist")
                    Spacer()
                } else {
                    Text("Search for a friend to add")
                    Spacer()
                }
            }
            .frame(height: 250)
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
    FriendAddView().environmentObject(FriendStore()).environmentObject(FoundUser())
}
