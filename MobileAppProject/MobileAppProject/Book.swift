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
    var bookImage = ""
    
    init(_ bookTitle: String, _ bookISBN: String, _ bookCondition: String, _ bookPrice: Float, _ bookImage: String) {
        self.bookTitle = bookTitle
        self.bookISBN = bookISBN
        self.bookCondition = bookCondition
        self.bookPrice = bookPrice
        self.bookImage = bookImage
        
    }
}
