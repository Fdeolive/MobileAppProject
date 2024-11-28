//
//  Shelf.swift
//  MobileAppProject
//

import Foundation
import SwiftUICore
import SwiftUI

struct Shelf: Identifiable{
    let id = UUID()
    var shelfTitle = ""
    var shelfBooks = [Book]()
    
    init(_ shelfTitle: String, _ shelfBooks: [Book]) {
        self.shelfTitle = shelfTitle
        self.shelfBooks = shelfBooks
        
    }
}
