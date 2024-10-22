//
//  HomeView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/22/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView() {
            SearchView().tabItem() {
                Image(systemName: "map")
            }
        }
    }
}

#Preview {
    HomeView()
}
