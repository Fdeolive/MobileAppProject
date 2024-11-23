//
//  Loading.swift
//  MobileAppProject
//
//  Created by user267577 on 11/23/24.
//

import Foundation

class Loading: ObservableObject {
    @Published var isLoading = true
    
    init() {
        self.isLoading = true
    }
}
