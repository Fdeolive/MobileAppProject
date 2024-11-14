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
    @State var friendsList: [String] = ["john", "Joe", "Derrick"]
    @State private var searchText = ""
    var searchResults: [String] {
        if searchText.isEmpty {
            return friendsList
        } else {
            return friendsList.filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    @State var selection: String?
    var body: some View {
        NavigationView {
            GeometryReader { geometry in VStack
                {
                    HStack {
                        SearchBarView(searchText: "Search", searchingValue: $searchText, action: {})
                        Button(action: {}) {
                            Image(systemName: "person.badge.plus.fill").font(.title).padding(.trailing, 35)
                                .padding(.top, 10)
                        }.foregroundStyle(Color.green)
                    }
                    List {
                        ForEach(searchResults, id: \.self) { username in
                            NavigationLink {
                                SearchView()
                            } label: {
                                Text(username)
                            }
                        }.listRowSeparator(.hidden)
                            .listRowBackground(RoundedRectangle(cornerRadius: 20)
                                .fill(lighterGreen).overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.green, lineWidth: 2)
                                ))
                    }.environment(\.defaultMinListRowHeight, 100).listRowSpacing(10.0).scrollContentBackground(.hidden)
                }
            }
            
        }
    }
}

#Preview {
    FriendsView()
}
