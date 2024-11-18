//
//  FriendAddView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import SwiftUI

struct FriendAddView: View {
    
    @State private var searchText = ""
    @State var userExists = false
    @State var findUser = false
    private let lighterGreen = Color(red: 240/255, green: 255/255, blue: 240/255)
    
    
    var body: some View {
        VStack {
            HStack {
                SearchBarView(searchText: "Find for a friend", searchingValue: $searchText, action: {})
                Button("Find") {}
                    .foregroundStyle(Color.green)
                    .font(.title3)
                    .bold()
                    .padding(5)
                    .background(lighterGreen)
                    .overlay(Rectangle()
                        .stroke(Color.green, lineWidth: 2)).padding(.trailing, 20)
            }
            if userExists {
                Text("Exists")
            } else if userExists == false && searchText != "" && findUser != false {
                Text("The user you are searching for does not exist")
            }
        }
        .padding(10)
        .background(Color.white)
        .clipped()
        .cornerRadius(5)
        .padding(5)
        .shadow(color: Color.black, radius: 3)
    }
}

#Preview {
    FriendAddView()
}
