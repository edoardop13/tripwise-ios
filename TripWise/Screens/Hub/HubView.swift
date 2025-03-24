//
//  HubView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 26/01/25.
//

import SwiftUI

struct HubView: View {
    @State private var homeRouter: NavigationRouter<HomeNavigationPages> = .init()
    @State private var historyRouter: NavigationRouter<HistoryNavigationPages> = .init()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environment(homeRouter)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .environment(historyRouter)
        }
        .accentColor(.black)
    }
}
