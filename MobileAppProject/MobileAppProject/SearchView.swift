// Search Page View
// CS 3750
// Search page layout to match wireframe. Some sorting functionality added and some responses to different button toggles.

import SwiftUI

struct SearchView: View {
    // Variables holding what the user is searching for
    @State var searchingFor: String = ""
    // Toggles for certain filters when searching
    @State var conditionToggle = false
    @State var goodreadsToggle = false
    @State var wishlistToggle = false
    @State var priceRangeToggle = false
    // Price to filter by when searching
    @State var price: CGFloat = 100.0
    // Boolean to sort by asc or dsc
    @State var sortAsc = false
    // Dictionary for acceptable conditions when filtering
    @State var acceptableConditions = ["Like New": true,
    "Good": true,
                                       "Moderately Used": true,
                                       "Well Loved": true]
    @State var applyToggle = false
    // Pretend book objects for testing
    @State var books = [Book("Harry Potter", "1", "Like New", 5.00, "", ""), Book("1984", "2", "Well Loved", 3.00, "", ""), Book("Animal Farm", "3", "Moderately Used", 6.00, "", ""), Book("Brave New World", "4", "Good", 1.00, "", "")]
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    @State var booksToDisplay: [Bool] = []
    
    func resetOnConditions() {
        for i in 0..<booksToDisplay.count {
            booksToDisplay[i] = true
        }
        for (key, _) in acceptableConditions {
            acceptableConditions[key] = true
        }
        price = 100
        conditionToggle = false
        goodreadsToggle = false
        wishlistToggle = false
        priceRangeToggle = false
    }
    
    func addToDisplay() {
        for _ in books {
            booksToDisplay.append(true)
        }
    }
    
    // Function to sort books by asc or dsc
    func sortAscendingDescending() {
        if sortAsc {
            books.sort(by: { $0.bookTitle > $1.bookTitle })
        } else {
            books.sort(by:  { $0.bookTitle < $1.bookTitle })
        }
    }
    
    func sortOnConditions() {
        for i in 0..<books.count {
            booksToDisplay[i] = false
            if acceptableConditions[books[i].bookCondition]! == true {
                if books[i].bookPrice <= Float(price) {
                    if books[i].bookTitle == searchingFor || searchingFor == "" {
                        booksToDisplay[i] = true
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in VStack {
            VStack {
                // Search bar using SearchBarView
                SearchBarView(searchText: "Enter Title, Author, GoodReads, Score...", searchingValue: $searchingFor, action: { sortOnConditions() })
                VStack {
                    HStack {
                        // Asc/Dsc button
                        Button(sortAsc ? "ASC": "DSC", systemImage: sortAsc ? "arrow.up": "arrow.down", action: {sortAsc.toggle(); sortAscendingDescending()}).padding(5).foregroundColor(Color.black).font(.caption)
                        Spacer()
                    }
                    HStack {
                        // Filter buttons
                        Text("Filter:")
                        FilterButtonView(buttonText: "Condition", action: {conditionToggle.toggle(); if conditionToggle == false {
                            for (key, _) in acceptableConditions {
                                acceptableConditions[key] = true
                            }
                        }}, borderColor: conditionToggle ? green: white)
                        FilterButtonView(buttonText: "GoodReads", action: {goodreadsToggle.toggle()}, borderColor: goodreadsToggle ? green: white)
                        FilterButtonView(buttonText: "Wish List", action: {wishlistToggle.toggle()}, borderColor: wishlistToggle ? green: white)
                        FilterButtonView(buttonText: "Price Range", action: {priceRangeToggle.toggle(); if priceRangeToggle == false {
                            price = 100.0
                        }}, borderColor: priceRangeToggle ? green: white)
                    }.font(.caption).padding([.leading], 10)
                    
                    // Should load condition options if toggled
                    if conditionToggle {
                        // Buttons for condition options
                        HStack {
                            FilterButtonView(buttonText: "Like New", action: {acceptableConditions["Like New"]!.toggle()}, borderColor: acceptableConditions["Like New"]! ? green: white, buttonWidth: 175, buttonFontLarge: true)
                            FilterButtonView(buttonText: "Good", action: {acceptableConditions["Good"]!.toggle()}, borderColor: acceptableConditions["Good"]! ? green: white, buttonWidth: 175, buttonFontLarge: true)
                        }.padding([.top], 5)
                        HStack {
                            FilterButtonView(buttonText: "Moderately Used", action: {acceptableConditions["Moderately Used"]!.toggle()}, borderColor: acceptableConditions["Moderately Used"]! ? green: white, buttonWidth: 175, buttonFontLarge: true)
                            FilterButtonView(buttonText: "Well Loved", action: {acceptableConditions["Well Loved"]!.toggle()}, borderColor: acceptableConditions["Well Loved"]! ? green: white, buttonWidth: 175, buttonFontLarge: true)
                        }
                    }
                    // Slider for if price range is toggled
                    if priceRangeToggle {
                        HStack {
                            Slider(value: $price,
                                    in: 0...100,
                                    step: 1.0
                            ).padding([.top], 20)
                            Text("\(Int(price)) $").padding([.top], 20)
                            
                        }.frame(width: 350)
                    }
                    HStack {
                        Spacer()
                        Button("Cancel", action: { resetOnConditions() })
                        Button("Apply", action: { sortOnConditions() })
                    }.padding()
                }.frame(width: geometry.size.width - 10).background(Color.white).clipped().cornerRadius(5).padding(3)
                    .shadow(color: Color.black, radius: 3)
                // Scrolling for books
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            // Load each book
                            ForEach(Array(books.enumerated()), id: \.element.bookISBN) { index, book in
                                if booksToDisplay.count > 0 && booksToDisplay[index] == true {
                                    VStack {
                                        HStack {
                                            AsyncImage(url: URL(string: "https://books.google.com/books/content?id=tTIcIQAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")) { image in
                                                image.resizable().aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                Rectangle()
                                            }
                                            VStack(alignment: .leading) {
                                                Text("Title: \(book.bookTitle)")
                                                Text("ISBN: \(book.bookISBN)")
                                                Text("Condition: \(book.bookCondition)")
                                                Text(String(format: "Price: %.2f", book.bookPrice))
                                            }.padding().font(.callout)
                                            Spacer()
                                        }.padding()
                                    }.frame(width: geometry.size.width - 25, height: geometry.size.height / 5)
                                     .background(lightGreen).cornerRadius(20)
                                     .overlay(RoundedRectangle(cornerRadius: 15).stroke(green, lineWidth: 2))
                                     .padding(5)
                                }
                            }

                        }
                    }.defaultScrollAnchor(.top)
                }
            }.onAppear() { books.sort(by: { $0.bookTitle < $1.bookTitle }); addToDisplay()}
        }
        }
    }
}

#Preview {
    SearchView()
}
