// A Book object
// CS 3750
//

import SwiftUICore
import SwiftUI

class Book {
    
    var bookTitle = ""
    var bookISBN = ""
    var bookCondition = ""
    var bookPrice: Float = 0
    var bookImage = AsyncImage(url: URL(string: "www.google.com/url?sa=i&url=https%3A%2F%2Fwww.target.com%2Fp%2Fbrave-new-world-harper-perennial-modern-classics-by-aldous-huxley-paperback%2F-%2FA-77665223&psig=AOvVaw0ju5XDZc8Ag8mVNuaAW9D1&ust=1729089684266000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNDLzN_RkIkDFQAAAAAdAAAAABAE"))
    
    init(_ bookTitle: String, _ bookISBN: String, _ bookCondition: String, _ bookPrice: Float){//, _ bookImage: AsyncImage) {
        self.bookTitle = bookTitle
        self.bookISBN = bookISBN
        self.bookCondition = bookCondition
        self.bookPrice = bookPrice
        //self.bookImage = bookImage
        
    }
}
