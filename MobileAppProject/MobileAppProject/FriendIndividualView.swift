//
//  FriendIndividualView.swift
//  MobileAppProject
//
//  Created by user267577 on 11/18/24.
//

import SwiftUI

struct FriendIndividualView: View {
    @EnvironmentObject var friendStore: FriendStore
    @State var friendUsername: String
    @State var buttonText = ""
    
    @State var friendStatus = 0
    
    
    func updateFriendStatus() {
        var friendFound = false
        for friend in friendStore.allFriends {
            if friend.friendUsername == friendUsername {
                friendFound = true
                if friend.friendStatus == 1 || friend.friendStatus == 2 {
                    friendStore.delete(friend: friend)
                    friendStatus = 0
                    buttonText = "Add Friend"
                }
            }
        }
        if friendFound == false {
            friendStore.allFriends.append(Friend(friendUsername, 1))
            friendStatus = 1
            buttonText = "Cancel Request"
        }
        Task {
            do {
                await DBFriendConnect().updateFriendStatus(username: "cking", friendUsername: friendUsername, friendStatus:  friendStatus)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(friendUsername)
            Button(buttonText) { updateFriendStatus()
            }
            Text("\(friendStatus)")
        }.onAppear {
            var friendFound = false
            for friend in friendStore.allFriends {
                if friend.friendUsername == friendUsername {
                    friendStatus = friend.friendStatus
                    friendFound = true
                }
            }
            if friendFound == false {
                friendStatus = 0
            }
            switch friendStatus {
            case 0:
                buttonText = "Add Friend"
            case 1:
                buttonText = "Cancel Request"
            default:
                buttonText = "Remove Friend"
            }
        }
    }
}

#Preview {
    FriendIndividualView(friendUsername: "Joe").environmentObject(FriendStore())
}
