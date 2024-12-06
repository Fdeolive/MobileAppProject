//
//  IndividualBookView.swift
//  MobileAppProject
//
//  Work in progress
//  Display information about an indivual book
//Currently author title and image but future iteration should display more
//and be more asthetic

import SwiftUI

struct IndividualBookView: View {
    @State var book = Book("Harry Potter", "1234", "Like New", 5.00, "HP", ["JK"])
    @State var wishlist = false
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    private let conditionMap = ["4": "None", "3": "Worn in", "2": "Littly Used", "1": "Like New"]
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack() {
                    Text(book.bookTitle).font(.largeTitle).multilineTextAlignment(.center)
                    if book.bookAuthor.count != 0 {
                        Text("Author/s: \(book.bookAuthor)").font(.title2).multilineTextAlignment(.center)
                        
                    } else {
                        Text("Author: Unknown").font(.title2)
                    }
                    Spacer(minLength: geometry.size.height * 0.1 )
                    HStack(alignment: .center){
                        AsyncImage(url: URL(string: book.bookImage)){ image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                        }.frame(width: 250, height: 300).padding(1)
                        VStack{
                            if wishlist == true {
                                Text("\nMax Price: ")
                                Text("$\(book.bookPrice.formatted(.number.precision(.fractionLength(0...2))))")
                                Text("Condition wanted: ")
                                if let conditionString = conditionMap[book.bookCondition] {
                                    Text("\(conditionString)")
                                } else {
                                    Text("Worn in")
                                }
                            } else {
                                Text("condition wanted: ").foregroundStyle(lightGreen)
                            }
                        }
                            
                        
                    }
                    
                    
                }
                Spacer(minLength: geometry.size.height * 0.08)
                //Text("Overview:\n \(detail.volumeInfo.description ?? "No description avaliable")").padding(1)
            }
        }.background(lightGreen)
    }
    
    
    /*VStack{
     Text("\(book.bookTitle)").font(.system(size: 30, weight: .semibold))
     if (book.bookImage.count > 0){
     //Image(book.bookImage).resizable().aspectRatio(contentMode: .fit).frame(width: 136, height: 200).background(.gray)
     AsyncImage(url: URL(string: book.bookImage)){ image in
     image.resizable().aspectRatio(contentMode: .fit)
     } placeholder: {
     Rectangle().background(.gray)
     }.frame(width: 204, height: 300).background(.gray)
     }else{
     Text("No Image Available")
     .frame(width: 136, height: 200)
     .background(.gray)
     .foregroundColor(Color.white)
     .font(.system(size: 20, weight: .semibold))
     
     }
     Text("Author/s: \(book.bookAuthor)").font(.system(size: 20, weight: .semibold))
     //Here's some old code
     //This will be improved in a future iteration
     //right now it is functional but not great
     //Text("Price: \(book.bookPrice)").font(.system(size: 20, weight: .semibold))
     //Text("condition: \(book.bookCondition)").font(.system(size: 20, weight: .semibold))
     //Text("Rating: Filler").font(.system(size: 20, weight: .semibold))
     //Text("Summary: Filler\n  Filler...\n  Filler...\n").font(.system(size: 20, weight: .semibold))
     
     /*Text("Versions:")
      ScrollView(.horizontal){
      HStack(spacing: 20){
      Rectangle()
      .fill(.white)
      .frame(width: 10, height: 100)
      ForEach(0..<3){i in
      Rectangle()
      .fill(.red)
      .frame(width: 68, height: 100)
      }
      }.padding()
      }*/
     }
     Spacer()*/

}

#Preview {
    IndividualBookView(book: Book("Harry Potter", "1234", "Like New", 5.00, "HP", ["JK"]), wishlist: false)
}
