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
import FirebaseAuth



struct searchFriends: View{
    var user: User?
    var bookTitles : String
    @State var friendsList: [String] = []
    @State var inFriendsList: [String] = []
    @State var printFriends = false
    let db = Firestore.firestore()
    @State var collectionName = ""
    @State var checkingFriend = "false"
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    
    
    @State private var selectedPrice = 0
    let priceOptions =  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    @State private var selectedCondition = "None"
    let conditonOptions = ["None","Worn in","Littly Used","Like New"]
    //gets information from the user currently logged in to use for firebase queries 
    func getUserInfo() async
    {
        do{
            if Auth.auth().currentUser != nil {
                let userid = Auth.auth().currentUser!.uid
                let userRef = db.collection("user").whereField(
                    "uid", isEqualTo: userid)
                let userInfo = try await userRef.getDocuments()
                for docs in userInfo.documents
                {
                    collectionName = docs.get("username") as! String
                }
            }
        } catch
        {
            print("Error getting user information")
        }
    }
    //Sends all friends who have the book in their wishlist with the specific conditions a notification
    func sendingFriendsNotification(friendID: Array<String>, bookTitle: String, price: Int, condition: String) async
    {
        for friendId in friendID
        {
            let id = UUID().uuidString
            
            do {
                try await
                
                
                db.collection("user").document(friendId).updateData(["notifications.\(id).notificationTitle": "Wishlist book found","notifications.\(id).notificationSummary":" \(collectionName) found \(bookTitles) for the price: \(price) in the conditon:\(condition)", "notifications.\(id).friendUsername": ""])
                    print("Notification added successfully")
                
              
            }catch
            {
                print("Error sending notification")
            }
        }
    }
    //Finds all the friends with the specific book in their wishlist
    func FriendsWishList(condition: Int, price: Int, bookTitle: String) async
    {
       
        
        let docRef = db.collection("user").document(collectionName)
        do{
            let document = try await docRef.getDocument()
            if let friendMap = document.get("friends") as?  [String: Bool] {
                let friendsList = Array(friendMap.keys)
                self.friendsList = friendsList
            }
            
            for friend in friendsList
            {
                let docRef = db.collection("user").document(friend).collection("Wishlist")
                do {
                    
                    let docqueryCompound = docRef
                        .whereField("title", isEqualTo: bookTitle)
          
                    let docquery = try await docqueryCompound.getDocuments()
                    
                        if (docquery.documents.count != 0)
                    {
                            //Had to do it like this because firebase doesn't like when multiple inequalities is used for a query 
                            for docs in docquery.documents
                            {
                                let priceSelected = docs.get("price") ?? 9
                                let conditionSelected=docs.get("condition") ?? 9
                                print(conditionSelected)
                                if(priceSelected as! Int >= price && conditionSelected as! Int >= condition)
                                {
                                    inFriendsList.append(friend)
                                }
                            }
                           
                                        
                                
                            
                        }
                       
                } catch {
                    print("Error querying friends' \(error)")
                    
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
                Picker("Condition", selection: $selectedCondition) {
                    ForEach(conditonOptions, id: \.self) {
                        Text(String($0))
                    }
                    
                }
            }
            Button("Search")
            {
                
                var conditionValue = 4
                let conditionMap = ["None": 4,"Worn in": 3 ,"Littly Used": 2,"Like New": 1]
                conditionValue = conditionMap[selectedCondition] ?? 4
                Task
                {
                    await
                    FriendsWishList(condition: conditionValue, price: selectedPrice, bookTitle:bookTitles)
                    
                    printFriends = true
                }
                
                
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
                        VStack(){
                            Text("In friend's wishlist:").font(.title2)
                            List(inFriendsList, id:\.self){ friend in
                                HStack(){
                                    Spacer()
                                    Text(friend).font(.title3)
                                    Spacer()
                                }
                                 }.listStyle(.plain)
                                .background(white.opacity(0.3))
                            
                        
                    }.background(lightGreen).cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(green, lineWidth: 2))
                        .padding(5)
                    
                    Button("Notify")
                    {
                    
                           Task
                            {
                                await
                                sendingFriendsNotification(friendID:friendsList, bookTitle: bookTitles, price: selectedPrice, condition: selectedCondition)
                            }
                            
                        
                       
                    }
                    
                }
            }
        }.onAppear()
        {
            Task
            {
                await getUserInfo()
            }
        }
    }
}





#Preview {
    searchFriends(bookTitles: "Fourth Wing")
}

