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
    @State var price: CGFloat = 0
    // Boolean to sort by asc or dsc
    @State var sortAsc = true
    // Dictionary for acceptable conditions when filtering
    @State var acceptableConditions = ["Like New": false,
    "Good": false,
                                       "Moderately Used": false,
                                       "Well Loved": false]
    @State var applyToggle = false
    // Pretend book objects for testing
    @State var books = ["Harry Potter", "1984", "Animal Farm", "Brave New World"]
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    // Function to sort books by asc or dsc
    func sortAscendingDescending() {
        if sortAsc {
            books.sort(by: >)
        } else {
            books.sort(by: <)
        }
    }
    
    var body: some View {
        VStack {
            // Should be done in Main View
            Text("Search For A Book").frame(width: 450).padding([.bottom]).background(darkGreen).foregroundColor(white).bold().font(.title2)
            
            // Search bar
            TextField("Enter Title, Author, GoodReads Score...", text: $searchingFor).padding(10).background(lightGreen).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 2)).padding([.leading, .trailing], 30).padding([.top, .bottom], 10)
            
            VStack {
                
                HStack {
                    // Asc/dsc button
                    Button(sortAsc ? "ASC": "DSC", systemImage: sortAsc ? "arrow.up": "arrow.down", action: {sortAsc.toggle(); sortAscendingDescending()}).padding(5).foregroundColor(Color.black).font(.caption)
                    Spacer()
                }
                
                HStack {
                    // Filter buttons
                    Text("Filter:")
                    FilterButtonView(buttonText: "Condition", action: {conditionToggle.toggle()}, borderColor: conditionToggle ? green: white)
                    FilterButtonView(buttonText: "GoodReads", action: {goodreadsToggle.toggle()}, borderColor: goodreadsToggle ? green: white)
                    FilterButtonView(buttonText: "Wish List", action: {wishlistToggle.toggle()}, borderColor: wishlistToggle ? green: white)
                    FilterButtonView(buttonText: "Price Range", action: {priceRangeToggle.toggle()}, borderColor: priceRangeToggle ? green: white)
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
                HStack {
                    // Slider for if price range is toggled
                    if priceRangeToggle {
                        Slider(value: $price,
                                   in: 0...100,
                                   step: 5.0
                        ).padding([.top], 20)
                        Text("\(Int(price)) $").padding([.top], 20)
                        }
                }.frame(width: 350)
                HStack {
                    Spacer()
                    Button("Cancel", action: {})
                    Button("Apply", action: {})
                    }.padding()
            }.frame(width: 395).background(Color.white).clipped().cornerRadius(5).padding(3)
                .shadow(color: Color.black, radius: 3)
            // Scrolling for books
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        // Load each book
                        ForEach(0 ..< books.count) { i in
                            VStack {
                                Text("Book: \(books[i])")
                            }.frame(width: 375, height: 150).background(lightGreen).cornerRadius(20).overlay(RoundedRectangle(cornerRadius: 15).stroke(green, lineWidth: 2)).padding(5)
                        }
                    }
                }.defaultScrollAnchor(.top)
                // Should be in main view but this works for demonstration
                VStack {
                    Spacer()
                    Button("Go To ISBN Scanner", action: {}).padding(10).bold().font(.title3).frame(width: 350).background(darkGreen).foregroundColor(white).cornerRadius(10).padding([.bottom])
                }
            }
            HStack {
                Text("").frame(width: 450, height: 75).background(darkGreen)
            }
        }.onAppear() { sortAscendingDescending() }
    }
}

#Preview {
    SearchView()
}
