//
//  HomeView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/22/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var pageTitle: String = "Your Shelves"
    @State private var currentTab = 0
    @State var showIsbnButton = false
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in ZStack() {
                VStack {
                    Text(pageTitle).frame(width: geometry.size.width, height: geometry.size.height / 25).padding([.bottom]).background(darkGreen).font(.title).foregroundColor(Color.white).bold().padding([.bottom], 5)
                    TabView(selection: $currentTab) {
                        Group () {
                            BookCaseView().tabItem() {
                                Image(systemName: "book")
                            }.tag(0)
                            SearchView().tabItem() {
                                Image(systemName:"magnifyingglass")
                            }.tag(1)
                            NotificationsView().tabItem() {
                                Image(systemName:"bell")
                            }.tag(2)
                            FriendsView().tabItem() {
                                Image(systemName: "person.2.fill")
                            }.tag(3)
                        }.toolbarBackground(darkGreen, for: .tabBar).toolbarBackground(.visible, for: .tabBar).toolbarColorScheme(.dark, for:.tabBar)
                    }
                }.onChange(of: currentTab) {
                    switch currentTab {
                    case 0:
                        pageTitle = "Your Shelves"
                        showIsbnButton = false
                    case 1:
                        pageTitle = "Search For A Book"
                        showIsbnButton = true
                    case 2:
                        pageTitle = "Notfications"
                        showIsbnButton = false
                    case 3:
                        pageTitle = "Friends"
                        showIsbnButton = false
                    default:
                        showIsbnButton = false
                    }
                }
                if showIsbnButton {
                    VStack {
                        Spacer()
                        Button("Go To ISBN Scanner", action: {}).padding(10).bold().font(.title3).frame(width: geometry.size.width - 75).background(darkGreen).foregroundStyle(Color.white).cornerRadius(10).padding([.bottom], 65)
                    }
                }
            }
            }
        }
    }
}

#Preview {
    HomeView()
}

