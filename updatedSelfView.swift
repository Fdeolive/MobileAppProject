//
//  updatedSelfView.swift
//  Query
//
//  Created by Fernanda Girelli on 11/6/24.
//



import SwiftUI
import Vision
import FirebaseCore
import FirebaseFirestore



struct updatedSelfView: View{
    @ObservedObject var viewModel = ebookListModelView()
    var backgroundColor = Color(red: 230/255, green: 255/255, blue: 220/255)
    @State private var searchText = ""
    @State private var selectedBook: eBook.ID?
    
    var body: some View {
       
        NavigationStack {
            List(viewModel.eBooks) { eBook in
                NavigationLink(destination: bookView(detail: eBook)) {
                    HStack{
                        
                        let urlBook = String(eBook.volumeInfo.imageLinks.smallThumbnail)
                        
                        
                        let firstPart = urlBook[urlBook.startIndex...urlBook.index(urlBook.startIndex, offsetBy: 3)] + "s"
                        
                        let secondPart = urlBook[urlBook.index(urlBook.startIndex, offsetBy: 4)...urlBook.index(before: urlBook.endIndex)]
                        
                        
                        let modifiedText  = String(firstPart + secondPart)
                        
                        AsyncImage(url: URL(string: modifiedText)){ image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                        }
                        VStack{
                            Text(eBook.volumeInfo.title).font(.title)
                            
                            if let authors = eBook.volumeInfo.authors {
                                Text("By: \(authors.joined(separator: ", "))")
                            } else {
                                Text("Author: Unknown")
                                
                            }
                        }
                        
                    }
                }
            }
                }
                .searchable(text: $viewModel.searchTerm)
       
            }
        
    }

struct bookView: View {
    var detail: eBook
    
    var body: some View {
        VStack() {
            HStack{
                let urlBook = String(detail.volumeInfo.imageLinks.smallThumbnail)
                
                
                let firstPart = urlBook[urlBook.startIndex...urlBook.index(urlBook.startIndex, offsetBy: 3)] + "s"
                
                let secondPart = urlBook[urlBook.index(urlBook.startIndex, offsetBy: 4)...urlBook.index(before: urlBook.endIndex)]
                
                
                let modifiedText  = String(firstPart + secondPart)
                
                AsyncImage(url: URL(string: modifiedText)){ image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                }
                VStack{
                    Text(detail.volumeInfo.title)
                    if let authors = detail.volumeInfo.authors {
                        Text("By: \(authors.joined(separator: ", "))")
                    } else {
                        Text("Author: Unknown")
                        
                    }
                    do {
                      let querySnapshot = try await db.collection("cities").whereField("capital", isEqualTo: true)
                        .getDocuments()
                      for document in querySnapshot.documents {
                        print("\(document.documentID) => \(document.data())")
                      }
                    } catch {
                      print("Error getting documents: \(error)")
                    }

                }
                
            }
        }
    }
}



#Preview {
    updatedSelfView()
}

