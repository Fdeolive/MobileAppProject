//
//  AddShelfView.swift
//  MobileAppProject
//
//  View that enables user to add and remove shlves
//
//Good source of firebase info \/
//https://firebase.google.com/docs/firestore/manage-data/add-data#swift_9

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AddShelfView: View {
    
    func callGetShelvesLocal() {
        Task {
            do {
                await getShelvesLocal()
            }
        }
    }
    


    //Gets the array of shelves from firebase
    func getShelvesLocal() async {
        let docRef = db.collection("user").document(username.username)
        do {
            let document = try await docRef.getDocument()
            if let shelves = document.get("bookShelves") as? [String] {
                shelfList = []
                for shelf in shelves {
                    shelfList.append(shelf)
                }
            } else {
                print("Error: getting shelves")
            }
        } catch {
            print("Error: getting doc for shelves")
        }
    }
    
    func callAddShelf() {
        Task {
            do {
                await addShelf()
                //update global
                await ShelvesGlobal(username: username.username).getShelves(shelvesGlobal: shelvesGlobal)
                await ShelvesGlobal(username: username.username).fillShelves(shelvesGlobal: shelvesGlobal)
            }
        }
    }

    //Calls callGetShelves to update from firebase.  Checks that shelfTitle is not in list
    //If not in list it adds it to the firebase and updates the local list
    func addShelf() async {
        let docRef = db.collection("user").document(username.username)//.collection("wishlist").document("Hp")
        
        do {
            if (!shelfList.contains(shelfTitle)){
                shelfList = shelfList + [shelfTitle]
                try await docRef.updateData([
                    "bookShelves": shelfList
                ])
                let shelfCollectionRef = db.collection("user").document(username.username).collection("\(shelfTitle)").document("")
                try await shelfCollectionRef.setData(["Title": "bookname"])//Filler book must be added to create collection
                print("Document successfully updated")
            }else{
                print("Shelf is a repeat")
            }
        } catch {
          print("Error updating document: \(error)")
        }
    }
    
    //Calls the function to remove a shelf then calls the functions to sync the global shelves to match
    func callRemoveShelf() {
        Task {
            do {
                await removeShelf()
                //updates global
                await ShelvesGlobal(username: username.username).getShelves(shelvesGlobal: shelvesGlobal)
                await ShelvesGlobal(username: username.username).fillShelves(shelvesGlobal: shelvesGlobal)
            }
        }
    }
    
    //function removes the shelf selected by picker
    func removeShelf() async {
        let docRef = db.collection("user").document(username.username)
        shelfList = shelfList.filter{ $0 != shelfToRemove}  //filters out shelf to remove
        do {
            try await docRef.updateData([
                "bookShelves": shelfList
            ])
            let docList = try await db.collection("user").document(username.username).collection(shelfToRemove).getDocuments()
            let collectionRef = db.collection("user").document(username.username).collection(shelfToRemove)
            for doc in docList.documents {  //removes ever single doc (book) from shelf thus deleting shelf
                print("\(doc.documentID)")
                try await db.collection("user").document(username.username).collection(shelfToRemove).document(doc.documentID).delete()
            }
        } catch {
            print("Error updating document: \(error)")
        }
        shelfToRemove = "\\Default"  //reset picker
    }
    
    let db = Firestore.firestore()
    @EnvironmentObject var username: Username
    @EnvironmentObject var shelvesGlobal: ShelvesGlobal
    @State var shelfList: [String] = []  //Holds shelves from firebase
    @State private var shelfTitle = ""  //holds entered title
    @State private var shelfToRemove = "\\Default"
    @State private var addedMessage = false
    @State private var NUM_DEFAULT_SHELVES = 2
    var body: some View {
        VStack{
            TextField("Enter Title", text: $shelfTitle)
                .onChange(of: shelfTitle) {  //prevents use of backspaces and limits to 50 characters
                    shelfTitle = String(shelfTitle.prefix(50)).replacingOccurrences(of: "\\", with: "")//.filter{ !"9\"".contains($0) }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .offset(y: -15)
                .textInputAutocapitalization(.never)
            Button(action: {callAddShelf(); addedMessage = true}){  //calls funtion to add title to firebase.  Only active if input and not in list already
                Text("Add Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfTitle.count < 1 || shelfList.contains(shelfTitle))
            .alert(isPresented: $addedMessage) {
                return Alert(title: Text("Shelf Added"),
                dismissButton: .default(Text("Great!")))
            }
            
            //Comment in if you want shelves visble as an array
            /*if (shelfList.count > 0){
                Text("\(shelfList)")
            }*/
            
            if (shelfList.count > NUM_DEFAULT_SHELVES){  //prevents removal of defaults
                HStack{
                    Text("Shelf to Remove")
                    //Picker used to select shelf to remove
                    Picker(selection: $shelfToRemove, label: EmptyView()) {
                        ForEach(NUM_DEFAULT_SHELVES...shelfList.count-1, id: \.self) {title in
                            Text(shelfList[title]).tag(shelfList[title])
                        }
                    }
                }
            }
            //Button to remove shelves base off of picker
            Button(action: {print("deleteButton"); callRemoveShelf()}){
                Text("Remove Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfToRemove == "\\Default") //Cannot hit remove button if on default
            
        }.onAppear(){callGetShelvesLocal()}
    }
}

#Preview {
    AddShelfView()
        .environmentObject(Username())
        .environmentObject(ShelvesGlobal())
}


