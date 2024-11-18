//
//  AddShelfView.swift
//  MobileAppProject
//
//  Created by user264275 on 11/14/24.
//

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
    


    func getShelves() async {
        let docRef = db.collection("user").document("DavidsTest")
        do {
            let document = try await docRef.getDocument()
            if let shelves = document.get("Shelves") as? [String] {
                shelfList = []
                for shelf in shelves {
                    shelfList.append(shelf)
                }
            } else {
                print("nope")
            }
        } catch {
            print("error getting doc")
        }
    }
    
    func callAddShelf() {
        Task {
            do {
                await addShelf()
            }
        }
    }

    func addShelf() async {
        let docRef = db.collection("user").document("DavidsTest")
        do {
            if (!shelfList.contains(shelfTitle)){
                shelfList = shelfList + [shelfTitle]
                try await docRef.updateData([
                    "Shelves": shelfList// + [shelfTitle]
                ])
                print("Document successfully updated")
            }else{
                print("repeat")
            }
        } catch {
          print("Error updating document: \(error)")
        }
    }
    let db = Firestore.firestore()
    @State var shelfList: [String] = []
    @State private var shelfTitle = ""
    var body: some View {
        VStack{
            TextField("Enter Title", text: $shelfTitle)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .offset(y: -15)
            Button(action: {callAddShelf()}){
                Text("Add Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfTitle.count < 1)
            Button(action: {callGetShelves(); print(shelfList)}){
                Text("Show Shelves")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            if (shelfList.count > 0){
                Text("\(shelfList)")
            }
        }.onAppear(){callGetShelves()}
    }
}

#Preview {
    AddShelfView()
}
