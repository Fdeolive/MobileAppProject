//
//  DBShelvesConnect.swift
//  MobileAppProject
//
//  Created by user264275 on 11/26/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBShelvesConnect {
    
    // Get db
    let db = Firestore.firestore()
    private var username = ""
    
    init(username: String) {
        self.username = username
    }
    
    
    func getShelves(shelvesGlobal: ShelvesGlobal) async {
        let docRef = db.collection("user").document(username)
        do {
            let document = try await docRef.getDocument()
            if let shelves = document.get("bookShelves") as? [String] {
                DispatchQueue.main.async {
                    shelvesGlobal.shelfTitles = []
                }
                for shelf in shelves {
                    DispatchQueue.main.async {
                        shelvesGlobal.shelfTitles.append(shelf)
                    }
                }
            } else {
                print("Error: getting shelves")
            }
        } catch {
            print("Error: getting doc for shelves")
        }
    }
    
    func callGetShelves(shelvesGlobal: ShelvesGlobal) {
        Task {
            do {
                await getShelves(shelvesGlobal: shelvesGlobal)
            }
        }
    }
    
    func fillShelves(shelvesGlobal: ShelvesGlobal) async {
        do{
            let docRef = db.collection("user").document(username)
            for shelf in shelvesGlobal.shelfTitles{
                let docList = try await docRef.collection(shelf).getDocuments()
                for doc in docList.documents {
                    print("\(doc.documentID) => \(doc.data())")
                }
            }
        }catch{
            print("Error: \(error)")

        }
    }
    
    
}
