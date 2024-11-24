// Class to track if loading is complete
// Loading.swift
// MobileAppProject
// Carson J. King

import Foundation

class Loading: ObservableObject {
    @Published var isLoading = true
    
    init() {
        self.isLoading = true
    }
}
