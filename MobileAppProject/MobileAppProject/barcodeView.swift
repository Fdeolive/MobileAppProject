//
//  barcodeView.swift
//  MobileAppProject
//
//  Created by Fernanda Girelli on 11/18/24.
//



import SwiftUI
import CodeScanner
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct isbnSearch: View {
    @ObservedObject var viewModel = ebookListModelView()
    
    @State var inWishList = "No"
    let db = Firestore.firestore()
    @State var collectionName = ""
    @State var checkingFriend = "false"
    @Binding var searchTerms: String?

    
    
    // Important app colors
    private let lightGreen = Color(red: 230/255, green: 255/255, blue: 220/255)
    private let darkGreen = Color(red: 0/255, green: 125/255, blue: 50/255)
    private let green = Color.green
    private let white = Color.white
    
    
    
    @State private var selectedPrice = 0
    let priceOptions =  [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    @State private var selectedConition = "None"
    let conditonOptions = ["None","Worn in","Littly Used","Like New"]

    //Gets current user's username to use for firebase
    func getUserInfo() async
    {
        do{
            if Auth.auth().currentUser != nil {
                let userid = Auth.auth().currentUser!.uid
                let userRef = db.collection("user").whereField(
                    "uid", isEqualTo: userid)
                let userInfo = try await userRef.getDocuments()
                for docs in userInfo.documents
                {
                    collectionName = docs.get("username") as! String
                }
            }
        } catch
        {
            print("Error getting user information")
        }
    }
    
    //Checks to see if book is in the users peronal book shelve
    func inPersonalWishList(bookTitle: String) async
    {
        let docRef = db.collection("user").document(collectionName).collection("Wishlist")
        do {
            
            let docquery = try await docRef.whereField("title", isEqualTo: bookTitle).getDocuments()
            
                if (docquery.documents.count == 0)
                {
                    inWishList = "No"
                }
                else
                {
                    inWishList = "Yes"
                }

        } catch {
            print("Error getting document: \(error)")
            
        }
    }
    //Fixing link for book image
    func fixingimageLink(urlBook:String)->String
    {
        let firstPart = urlBook[urlBook.startIndex...urlBook.index(urlBook.startIndex, offsetBy: 3)] + "s"
        let secondPart = urlBook[urlBook.index(urlBook.startIndex, offsetBy: 4)...urlBook.index(before: urlBook.endIndex)]
        let modifiedLink  = String(firstPart + secondPart)
        return modifiedLink
    }
   
   
    
    var body: some View {
                Section {
                        NavigationStack{
                        List(viewModel.eBooks) { eBook in
                            ScrollView{
                                VStack(alignment: HorizontalAlignment.center){
                                    Text(eBook.volumeInfo.title).font(.largeTitle).multilineTextAlignment(.center)
                                    
                                    Spacer()
                                    if let authors = eBook.volumeInfo.authors {
                                        Text("By: \(authors.joined(separator: ", "))").font(.title2).multilineTextAlignment(.center)
                                    } else {
                                        Text("Author: Unknown")
                                        
                                    }
                                    Spacer()
                                    if let rating = eBook.volumeInfo.averageRating {
                                        Text("Rating:\(rating, specifier:"%.2f")")
                                    }
                                    
                                    
                                    Spacer(minLength: 50)
                                    Text(" On your wish list: \(inWishList)").font(.title3)
                                    
                                    NavigationLink(destination: searchFriends(bookTitles: eBook.volumeInfo.title)) {
                                       Text("Check Friends' Wishlist").fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(green)
                                            .cornerRadius(8)
                                            .shadow(radius: 5)
                                    }
                                    .padding()
                                    
                                     
                                    let modifiedText  = fixingimageLink(urlBook: String(eBook.volumeInfo.imageLinks.smallThumbnail))
                                                                        
                                    Spacer(minLength: 50)
                                    
                                    AsyncImage(url: URL(string: modifiedText)) { image in
                                        image
                                            .resizable()
                                        
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 250, height: 300)
                                }
                                
                                
                            }
                        }.listStyle(.plain)
                            .background(white.opacity(0.3))
                     } }header:
                        {
                           ZStack
                            {
                                darkGreen
                                 .edgesIgnoringSafeArea(.all)
                                Text("Successfully Scanned")
                                    .foregroundColor(.white).font(.title2).fontWeight(.bold)
                                    
                                }.frame(height:55).onAppear()
                        }.onAppear()
                            {
                            //Takes the isbn scanned and uses it to call the google book api  
                            if let searchTerms = searchTerms {
                                        viewModel.searchTerm = searchTerms
                                    }
                                Task
                                {
                                    await getUserInfo()
                                    //Gets the title of the book scanned and searched all user's friends' wishlist
                                    if let firstBook = viewModel.eBooks.first
                                    {
                                                await inPersonalWishList(bookTitle: firstBook.volumeInfo.title)
                                    }
                            }
  
        }
    }
}


struct barCodeView: View
{
    @State private var showDetails = false
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var moveScreen = false
    @State private var fullRequest : String?
    @StateObject var viewModel = ebookListModelView()
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
               
            Text("No Book scanned")
                Button("Scanner")
                                {
                                    isPresentingScanner = true
                                }.padding(10)
                                    .bold()
                                    .font(.title3)
                                    .background(darkGreen)
                                    .foregroundStyle(Color.white)
                                    .cornerRadius(10)
                                    .padding([.bottom], 65)
                
              
            }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.ean8, .ean13, .upce, .code128, .code39, .pdf417]) { response in
                    if case let .success(result) = response {
                        scannedCode = ("isbn:\(result.string)")
                        isPresentingScanner = false
                        fullRequest = "Yes"
                        if fullRequest != nil
                        {
                            moveScreen = true
                        }
                        
                    }
                }
            }
            .navigationDestination(isPresented: $moveScreen)
                        {
                            //Shows the book info as soon as it is scanned
                            isbnSearch( searchTerms: $scannedCode)
                           
                                }
          
        }.onAppear()
        {
            //Allows the camera to pop up right as the page opens
            isPresentingScanner = true
        }
            }
    
}




