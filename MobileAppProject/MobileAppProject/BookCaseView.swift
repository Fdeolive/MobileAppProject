//
//  ContentView.swift
//  BookCaseDesign
//
//
//Displays a bookcase of all of the shelves
//User can add or remove shelves


import SwiftUI

struct BookCaseView: View {
    
    //Refreshes the shelves (have to hit twice sometimes tho)
    func refresh() {
        Task {
            do {
                await ShelvesGlobal(username: username.username).getShelves(shelvesGlobal: shelvesGlobal)
                await ShelvesGlobal(username: username.username).fillShelves(shelvesGlobal: shelvesGlobal)

            }
        }
    }

    
    @EnvironmentObject var username: Username  //username for firebase
    @EnvironmentObject var shelvesGlobal: ShelvesGlobal  //global shelf storage
    @State private var addBook = false
    @State private var shelves = [Shelf]()
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading) {
                    //Button for adding books
                    Button(action: {print("Add shelf button"); addBook = true}) {
                        Text("Add +  /  Remove -").padding()
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.width * 0.68,
                                   height: 35, alignment: .leading)
                            .foregroundColor(Color.white)
                            .background(.brown)
                            .cornerRadius(10)
                    }.padding()
                    
                    //Button to refresh
                    Button(action: {
                        print(shelvesGlobal.shelves)
                        refresh()
                        shelves = shelvesGlobal.shelves
                    }) {
                        Text("Refresh").padding()
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.width * 0.68,
                                   height: 35, alignment: .leading)
                            .foregroundColor(Color.white)
                            .background(.brown)
                            .cornerRadius(10)
                    }.padding()

                    /*ForEach(0..<shelvesGlobal.shelves.count, id: \.self){shelf in
                        ShelfView(shelfTitle: shelvesGlobal.shelves[shelf].shelfTitle, books: shelvesGlobal.shelves[shelf].shelfBooks)
                    }
                    ForEach(shelvesGlobal.shelves, id: \.id){shelf in
                        ShelfView(shelfTitle: shelf.shelfTitle, books: shelf.shelfBooks)
                    }*/
                    /*ForEach(0..<shelves.count, id: \.self){shelf in
                        ShelfView(shelfTitle: shelves[shelf].shelfTitle, books: shelves[shelf].shelfBooks)
                    }*/
                    ForEach(shelves, id: \.id){shelf in
                        ShelfView(shelfTitle: shelf.shelfTitle, books: shelf.shelfBooks)
                    }


                    
                    /*ShelfView(shelfTitle: myShelf.shelfTitle, books: myShelf.shelfBooks)
                    ShelfView(shelfTitle: "t2", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""), Book("1984", "1234", "Well Loved", 3.00, "", ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", ""), Book("Brave New World", "1234", "Good", 1.00, "", "")])
                    ShelfView(shelfTitle: "t3", books: [Book("Harry Potter", "1234", "Like New", 5.00, "HP", ""), Book("1984", "1234", "Well Loved", 3.00, "", ""), Book("Animal Farm", "1234", "Moderately Used", 6.00, "", ""), Book("Brave New World", "1234", "Good", 1.00, "", "")])
                    ShelfView(shelfTitle: "empty but also really long title", books: [])*/
                }
            }.navigationDestination(isPresented: $addBook) {AddShelfView()}
        }.refreshable{
            await ShelvesGlobal(username: username.username).getShelves(shelvesGlobal: shelvesGlobal)
            await ShelvesGlobal(username: username.username).fillShelves(shelvesGlobal: shelvesGlobal)
            shelves = shelvesGlobal.shelves
        }.onAppear(){
            //set shelves to whatever is stored
            shelves = shelvesGlobal.shelves
        }
    }
    
}

#Preview {
    BookCaseView()
        .environmentObject(Username())
        .environmentObject(ShelvesGlobal())
}
