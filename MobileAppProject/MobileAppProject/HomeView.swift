//
//  HomeView.swift
//  MobileAppProject
//
//  Created by user267577 on 10/22/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var pageTitle: String = "Shelves"
    @State private var currentTab = 0
    @State var showIsbnButton = false
    private let darkGreen = Color(red: 50/255, green: 150/255, blue: 50/255)
    
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in ZStack() {
                VStack(spacing: 0) {
                    VStack {
                    }.frame(width: geometry.size.width, height: 5).background(Color.black)
                    ZStack {
                        HStack {
                            Spacer()
                            Text(pageTitle)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            NavigationLink {
                                NotificationView()
                            } label: {
                                Image(systemName: "bell.fill")
                            }.padding(25)
                        }
                    }.frame(width: geometry.size.width, height: 60).background(darkGreen).font(.title).foregroundColor(Color.white).bold()
                    TabView(selection: $currentTab) {
                        Group () {
                            BookCaseView().tabItem() { Image(systemName: "book")
                            }.tag(0)
                            fixingShelfView().tabItem() {
                                Image(systemName: "magnifyingglass")
                            }.tag(1)
                            barCodeView().tabItem() {
                                Image(systemName: "barcode.viewfinder")
                            }.tag(2)
                            FriendView().tabItem() {
                                Image(systemName: "person.2.fill")
                            }.tag(3)
                            FriendView().tabItem() {
                                Image(systemName: "person.fill")
                            }.tag(4)                                }
                        .toolbarBackground(darkGreen, for: .tabBar).toolbarBackground(.visible, for: .tabBar).toolbarColorScheme(.dark, for:.tabBar)
                    }
                    VStack {
                    }.frame(width: geometry.size.width, height: 5).background(Color.black)
                }.onChange(of: currentTab) {
                    switch currentTab {
                    case 0:
                        pageTitle = "Shelves"
                        showIsbnButton = false
                    case 1:
                        pageTitle = "Search"
                        showIsbnButton = true
                    case 2:
                        pageTitle = "Scanner"
                        showIsbnButton = false
                    case 3:
                        pageTitle = "Friends"
                        showIsbnButton = false
                    case 4:
                        pageTitle = "Profile"
                        showIsbnButton = false
                    default:
                        showIsbnButton = false
                    }
                }
                if showIsbnButton {
                    VStack {
                        Spacer()
                        Button("Go To ISBN Scanner", action: { currentTab = 2}).padding(10).bold().font(.title3).frame(width: geometry.size.width - 75).background(darkGreen).foregroundStyle(Color.white).cornerRadius(10).padding([.bottom], 65)
                    }
                }
            }
            }
        }.tint(Color.green)
    }
}

#Preview {
    HomeView().environmentObject(NotificationStore()).environmentObject(FriendStore()).environmentObject(FoundUser())
}

