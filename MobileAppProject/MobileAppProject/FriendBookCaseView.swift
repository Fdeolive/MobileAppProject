//
//  ContentView.swift
//  BookCaseDesign
//
//
//Displays a bookcase of all of the shelves
//User can add or remove shelves


import SwiftUI

struct FriendBookCaseView: View {
    
    //Refreshes the shelves (have to hit twice sometimes tho)
    func refresh() {
        Task {
            do {
                await FriendShelvesGlobal(username: friendUsername).getShelves(friendShelvesGlobal: friendShelvesGlobal)
                await FriendShelvesGlobal(username: friendUsername).fillShelves(friendShelvesGlobal: friendShelvesGlobal)
                DispatchQueue.main.async {
                    shelves = friendShelvesGlobal.shelves
                }
            }
        }
    }

    
    @EnvironmentObject var username: Username  //username for firebase
    @EnvironmentObject var friendShelvesGlobal: FriendShelvesGlobal  //global shelf storage
    @State var friendUsername: String
    @State private var addBook = false
    @State private var shelves = [Shelf]()
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(shelves, id: \.id){shelf in
                        FriendShelfView(shelfTitle: shelf.shelfTitle, books: shelf.shelfBooks)
                    }
                }
            }.navigationDestination(isPresented: $addBook) {AddShelfView()}
                
        }.refreshable{
            refresh()
        }.onAppear(){
            //set shelves to whatever is stored
            refresh()
        }
    }
    
}

#Preview {
    FriendBookCaseView(friendUsername: "Joe")
        .environmentObject(Username())
        .environmentObject(FriendShelvesGlobal())
}
