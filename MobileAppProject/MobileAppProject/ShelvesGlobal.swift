//
//  ShelvesGlobal.swift
//  MobileAppProject
//
//  Created by user264275 on 11/26/24.
//

import Foundation
import SwiftUICore
import SwiftUI

import FirebaseCore
import FirebaseFirestore

//Class to store the user's books and shelves upon retrieveal from firebase

@MainActor//This is needed because fillShelves has an increment counter that doesn't work with DispatchQueue
class ShelvesGlobal: ObservableObject {
    @Published var shelves: [Shelf]  //array of shelves as shelf classes
    @Published var shelfTitles: [String]  //array of titles of shelves
    
    init() {
        shelves = []
        shelfTitles = []
        username = ""
    }
    
    
    // Get db
    let db = Firestore.firestore()
    private var username = "" //username for firebase access
    
    init(username: String) {
        shelves = []
        shelfTitles = []
        self.username = username
    }
    
    //Populetaes shelfTitles with the shelf titles from Firebase
    func getShelves(shelvesGlobal: ShelvesGlobal) async {
        let docRef = db.collection("user").document(username)
        do {
            let document = try await docRef.getDocument()
            if let shelves = document.get("bookShelves") as? [String] {
                shelvesGlobal.shelfTitles = [] //clear array
                for shelf in shelves { //add shelves
                    shelvesGlobal.shelfTitles.append(shelf)
                }
            } else {
                print("Error: getting shelves")
            }
        } catch {
            print("Error: getting doc for shelves")
        }
    }
    
    //Calls getShelves function to populate list with shelf titles
    func callGetShelves(shelvesGlobal: ShelvesGlobal) {
        Task {
            do {
                await getShelves(shelvesGlobal: shelvesGlobal)
            }
        }
    }
    
    //Must occur after getShelfList
    //For each shelf in the global shelf list it will add a new shelf to the global
    //shelf array and populate it with books
    func fillShelves(shelvesGlobal: ShelvesGlobal) async {
        do{
            let docRef = db.collection("user").document(username)
            shelvesGlobal.shelves = [] //clear shelves
            var increment = 0 //increments what shelf in array
            //For each shelf title add a shelf of that title to the array of shelves
            for shelf in shelvesGlobal.shelfTitles{
                shelvesGlobal.shelves.append(Shelf(shelf, []))
                let docList = try await docRef.collection(shelf).getDocuments()
                //Each doc is a book add them all to the shelf
                for doc in docList.documents {
                    print(shelvesGlobal.shelves[increment].shelfTitle)
                    print("\(doc.documentID) => \(doc.data())")
                    //print("\(doc.data()["title"] ?? "NA")")  //testingh code you can comment in
                    //print("increment= \(increment)")
                    shelvesGlobal.shelves[increment].shelfBooks.append(
                        Book("\(doc.data()["title"] ?? "NA")", "\(doc.data()["ISBN"] ?? "0000")", "\(doc.data()["condition"] ?? "None")", Float("\(doc.data()["price"] ?? 0)")!, "\(doc.data()["image"] ?? "")", doc.data()["authors"] as? [String] ?? ["NA"]))//["author"]))//doc.data()["author"] ?? ["NA"])))
                }
                shelvesGlobal.shelves[increment].shelfBooks.removeFirst() //Removes the filler book used to create collection
                increment += 1
            }
        }catch{
            print("Error: \(error)")

        }
    }
    
    //Calls fillshelves to populate the array of shelves with shelves/books
    func callFillShelves(shelvesGlobal: ShelvesGlobal) {
        Task {
            do {
                await fillShelves(shelvesGlobal: shelvesGlobal)
            }
        }
    }
    
}
