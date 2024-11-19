//
//  boookview.swift
//  MobileAppProject
//
//  Created by Fernanda Girelli on 11/17/24.
//

import SwiftUI


import SwiftUI
import Vision
import FirebaseCore
import FirebaseFirestore



struct searchFriends: View{
    var bookTitles : String
    @State var friendsList: [String] = []
    @State var inFriendsList: [String] = []
    @State var printFriends = false
    let db = Firestore.firestore()
    let collectionName = "username"
    @State var checkingFriend = "false"
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    
    
    @State private var selectedPrice = 0
    let priceOptions =  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    @State private var selectedConition = "None"
    let conditonOptions = ["None","Worn in","Littly Used","Like New"]
    
    
    func FriendsWishList(condtion: String, price: Int, bookTitle: String) async
    {
        let docRef = db.collection("user").document(collectionName)
        do{
            let document = try await docRef.getDocument()
            if let friendList = document.get("friends") as? [String] {
                self.friendsList = Array(friendList)
            }
            
            for friend in friendsList
            {
                let docRef = db.collection("user").document(friend).collection("wishlist")
                do {
                    
                    let docquery = try await docRef.whereField("title", isEqualTo: bookTitle).getDocuments()
                    
                        if (docquery.documents.count != 0)
                        {
                            inFriendsList.append(friend)
                        }
                       

                } catch {
                    print("Error getting document: \(error)")
                    
                }
            }
            print(inFriendsList)
            
        }
        catch {
            print("Error getting document:")
            
        }
    }
    
   
    var body: some View {
        VStack{
            Text("Search Condition").font(.largeTitle)
            HStack{
                Text("Current Price (Rounded Up) $")
                Picker("Price", selection: $selectedPrice) {
                    ForEach(priceOptions, id: \.self) {
                        Text(String($0))
                    }
                    
                }
            }
            HStack{
                Text("Current Condition")
                Picker("Condition", selection: $selectedConition) {
                    ForEach(conditonOptions, id: \.self) {
                        Text(String($0))
                    }
                    
                }
            }
            Button("Search")
            {
                Task
                {
                    await
                    FriendsWishList(condtion: selectedConition, price: selectedPrice, bookTitle:bookTitles)
                }
                printFriends = true
                
            }
            .padding()
            .background(green)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            
            
            
            if (printFriends == true)
            {
                if(inFriendsList.count==0)
                {
                    
                    Text("Does not match any books in your friends' wishlist").font(.title2).border(green).cornerRadius(2).padding(3)
                }
                else{
                    List(inFriendsList, id:\.self){ friend in
                        Text(friend)}
                    Button("Notify")
                    {
                        print("Notified the peeps")
                    }
                    
                }
            }
        }
    }
}





#Preview {
    searchFriends(bookTitles: "Fourth Wing")
}
