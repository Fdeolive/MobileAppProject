//
//  FixingShelf.swift
//  MobileAppProject
//
//  Created by Fernanda Girelli on 11/18/24.
//

import SwiftUI
import Vision
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



struct fixingShelfView: View{
    
    @ObservedObject var viewModel = ebookListModelView()
    var backgroundColor = Color(red: 230/255, green: 255/255, blue: 221/255)
    @State private var searchText = ""
    @State private var selectedBook: eBook.ID?
    
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    
    //Updates the search terms used to call the google books api
    func apiSearchTerm(searchTerms: String?)
    {
        if let searchTerms = searchTerms {
            viewModel.searchTerm = searchTerms
        }
    }
    //Modified image link so its https instead of http
    func fixingimageLink(urlBook:String)->String
    {
        let firstPart = urlBook[urlBook.startIndex...urlBook.index(urlBook.startIndex, offsetBy: 3)] + "s"
        let secondPart = urlBook[urlBook.index(urlBook.startIndex, offsetBy: 4)...urlBook.index(before: urlBook.endIndex)]
        let modifiedLink  = String(firstPart + secondPart)
        return modifiedLink
    }
    
    
    var body: some View {
       
        NavigationStack{
            ZStack {
                //Search box
                TextField(searchText, text: $searchText).padding(10).background(backgroundColor).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 2)).padding([.leading, .trailing], 30).padding([.top, .bottom], 10)
                
                Button("", systemImage: "magnifyingglass")
                {
                  viewModel.searchTerm = searchText
                    
                }.foregroundColor(green).padding([.leading], 310)
            }
            //Result of Api Call
            List(viewModel.eBooks) { eBook in
                NavigationLink(destination: SearchedBookView(detail: eBook)) {
                    VStack{
                        HStack{
                            
                            //Fixing the link to display the image
                            let modifiedText = fixingimageLink(urlBook: String(eBook.volumeInfo.imageLinks.smallThumbnail))
                          
                            
                            AsyncImage(url: URL(string: modifiedText)){ image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                            }
                            .frame(width: 200, height: 200).padding(5)
                            
                            VStack(alignment: .leading){
                                Text(eBook.volumeInfo.title).font(.title2)
                                if let authors = eBook.volumeInfo.authors {
                                    Text("By: \(authors.joined(separator: ", "))")
                                } else {
                                    Text("Author: Unknown")
                                    
                                }
                            }
                        }
                    }
                } .background(lightGreen).cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(green, lineWidth: 2))
                    .padding(5)
            }.listStyle(.plain)
                .background(white.opacity(0.3))
                
        }
        }
       }
        
    



#Preview {
    fixingShelfView()
}

