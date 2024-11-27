//
//  Shelf.swift
//  MobileAppProject
//

import Foundation
import SwiftUICore
import SwiftUI

class Shelf {
    
    var shelfTitle = ""
    var shelfBooks = [Book]()
    
    init(_ shelfTitle: String, _ shelfBooks: [Book]) {
        self.shelfTitle = shelfTitle
        self.shelfBooks = shelfBooks
        
    }
}
