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
    
    let db = Firestore.firestore()

    func getShelves() async {
        let docRef = db.collection("user").document("cking")
        do {
            let document = try await docRef.getDocument()
            if let shelves = document.get("friends") as? [String] {
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
            Button(action: {addShelf(shelfTitle: shelfTitle)}){
                Text("Add Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfTitle.count < 1)
            Button(action: {callGetShelves(); print(shelfList)}){
                Text("Add Shelf")
            }.padding()
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundStyle(.black)
            .disabled(shelfTitle.count < 1)
        }
    }
    func addShelf(shelfTitle: String){
        print(shelfTitle)
    }
}

#Preview {
    AddShelfView()
}
