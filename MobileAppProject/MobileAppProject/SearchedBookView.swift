//
//  SearchedBookView.swift
//  MobileAppProject
//
//  Created by Fernanda Girelli on 11/18/24.
//

import SwiftUI
import Vision
import FirebaseCore
import FirebaseFirestore


struct SearchedBookView: View {
    var detail: eBook
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    @State private var bookShelvesTitles: [String] = []
    @State private var selectedBookShelf = "wishlist"
    
    @State private var selectedPrice = 0
    let priceOptions =  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    @State private var selectedConition = "None"
    let conditonOptions = ["None","Worn in","Littly Used","Like New"]
    
    
    let db = Firestore.firestore()
    let collectionName = "username"
    
    
    
    func getBookShelves() async {
        let docRef = db.collection("user").document(collectionName)
        
        do {
            let document = try await docRef.getDocument()
            if let bookshelfItem = document.get("bookShelves") as? [String] {
                self.bookShelvesTitles = Array(bookshelfItem)
                print(bookShelvesTitles)
            }
        } catch {
            print("Error getting document: \(error)")
            
        }
    }
    
    
    func addToBookShelf(shelf:String, title:String, authors:[String]?, image:String, condition:String, price:Int) async
    {
        do{
            try await db.collection("user").document(collectionName).collection(shelf).document(detail.volumeInfo.title).setData(["title":title,"authors":authors ?? "NA","image":image, "condition":condition, "Price":price])
            
        }
        catch
        {
            print("Error setting book in sub-collection")
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            lightGreen
            ScrollView{
                VStack() {
                    
                    let urlBook = String(detail.volumeInfo.imageLinks.smallThumbnail)
                    
                    
                    let firstPart = urlBook[urlBook.startIndex...urlBook.index(urlBook.startIndex, offsetBy: 3)] + "s"
                    
                    let secondPart = urlBook[urlBook.index(urlBook.startIndex, offsetBy: 4)...urlBook.index(before: urlBook.endIndex)]
                    
                    
                    Text(detail.volumeInfo.title).font(.largeTitle).multilineTextAlignment(.center)
                    if let authors = detail.volumeInfo.authors {
                        Text("By: \(authors.joined(separator: ", "))").font(.title2).multilineTextAlignment(.center)
                    } else {
                        Text("Author: Unknown").font(.title2)
                    }
                    let modifiedText  = String(firstPart + secondPart)
                    Spacer(minLength: geometry.size.height * 0.1 )
                    HStack(alignment: .center){
                        AsyncImage(url: URL(string: modifiedText)){ image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                        }.frame(width: 250, height: 300).padding(1)
                        VStack{
                            
                            Text("Add to shelf: ")
                            Picker("Pick a shelf", selection: $selectedBookShelf) {
                                ForEach(bookShelvesTitles, id: \.self) {
                                    Text($0)
                                }
                                
                            }
                            
                            if(selectedBookShelf=="wishlist")
                            {
                                Text("\nMax Price: ")
                                Picker("Price", selection: $selectedPrice) {
                                    ForEach(priceOptions, id: \.self) {
                                        Text(String($0))
                                    }
                                    
                                }
                                Text("Condition wanted: ")
                                Picker("Condition", selection: $selectedConition) {
                                    ForEach(conditonOptions, id: \.self) {
                                        Text(String($0))
                                    }
                                    
                                }
                            }
                            Button("Add")
                            {
                                Task{
                                    await
                                    addToBookShelf(shelf: selectedBookShelf,title: detail.volumeInfo.title, authors: detail.volumeInfo.authors ?? ["NA"], image: detail.volumeInfo.imageLinks.smallThumbnail, condition:selectedConition, price:selectedPrice)
                                }
                                
                            }.padding()
                                .background(green)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                        
                        
                    }.onAppear
                    {
                        Task {await getBookShelves()}
                    }
                    Spacer(minLength: geometry.size.height * 0.08)
                    Text("Overview:\n \(detail.volumeInfo.description ?? "No description avaliable")").padding(1)
                }
            }
        }
  }
}


