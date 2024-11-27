//
//  ShelvesGlobal.swift
//  MobileAppProject
//
//  Created by user264275 on 11/26/24.
//

import Foundation
import SwiftUICore
import SwiftUI

class ShelvesGlobal: ObservableObject {
    @Published var shelves: [Shelf]
    @Published var shelfTitles: [String]
    
    init() {
        shelves = []
        shelfTitles = []
    }
}
