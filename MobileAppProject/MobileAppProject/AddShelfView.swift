//
//  AddShelfView.swift
//  MobileAppProject
//
//  Created by user264275 on 11/14/24.
//
//Good source of firebase info \/
//https://firebase.google.com/docs/firestore/manage-data/add-data#swift_9

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AddShelfView: View {
    
    func callGetShelves() {
        Task {
            do {
                await getShelves()
            }
        }
    }
    


    //Gets the array of shelves from firebase
    func getShelves() async {
        let docRef = db.collection("user").document("DavidsTest")
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
            }
        }
    }

    //Calls callGetShelves to update from firebase.  Checks that shelfTitle is not in list
    //If not in list it adds it to the firebase and updates the local list
    func addShelf() async {
        let docRef = db.collection("user").document("DavidsTest")//.collection("wishlist").document("Hp")
        
        do {
            if (!shelfList.contains(shelfTitle)){
                shelfList = shelfList + [shelfTitle]
                try await docRef.updateData([
                    "bookShelves": shelfList
                ])
                let shelfCollectionRef = db.collection("user").document("DavidsTest").collection("\(shelfTitle)").document("Book")
                try await shelfCollectionRef.setData(["Title": "bookname"])
                print("Document successfully updated")
            }else{
                print("Shelf is a repeat")
            }
        } catch {
          print("Error updating document: \(error)")
        }
    }
    
    
    func callRemoveShelf() {
        Task {
            do {
                await removeShelf()
            }
        }
    }
    
    func removeShelf() async {
        let docRef = db.collection("user").document("DavidsTest")
        shelfList = shelfList.filter{ $0 != pickerTitle}
        do {
            try await docRef.updateData([
                "bookShelves": shelfList
            ])
            let docList = try await db.collection("user").document("DavidsTest").collection(pickerTitle).getDocuments()
            let collectionRef = db.collection("user").document("DavidsTest").collection(pickerTitle)
            for doc in docList.documents {
                print("\(doc.documentID)")
                try await db.collection("user").document("DavidsTest").collection(pickerTitle).document(doc.documentID).delete()
            }
        } catch {
            print("Error updating document: \(error)")
        }
        pickerTitle = "Default"
    }
    
    let db = Firestore.firestore()
    @State var shelfList: [String] = []  //Holds shelves from firebase
    @State private var shelfTitle = ""  //holds entered title
    @State private var pickerTitle = "Default"
    @State private var num_default_shelves = 2
    @State private var colors = ["Red", "Green", "Blue"]
    //@State private var shelfList = ["Wishlist"]
    var body: some View {
        VStack{
            TextField("Enter Title", text: $shelfTitle)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .offset(y: -15)
            Button(action: {callAddShelf()}){  //calls funtion to add title to firebase.  Only active if input and not in list already
                Text("Add Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfTitle.count < 1 || shelfList.contains(shelfTitle))
            Button(action: {
                //callGetShelves()
                print(shelfList)
                print(pickerTitle)
            }
            ){
                Text("Show Shelves")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            if (shelfList.count > 0){
                Text("\(shelfList)")
            }
            if (shelfList.count > num_default_shelves){
                HStack{
                    Text("Shelf to Remove")
                    Picker(selection: $pickerTitle, label: EmptyView()) {
                        ForEach(num_default_shelves...shelfList.count-1, id: \.self) {title in
                            Text(shelfList[title]).tag(shelfList[title])
                        }
                    }
                }
            }
            Button(action: {print("deleteButton"); callRemoveShelf()}){
                Text("Remove Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(pickerTitle == "Default")
            
        }.onAppear(){callGetShelves()}
    }
}

#Preview {
    AddShelfView()
}


