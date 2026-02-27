//
//  ContentView.swift
//  traveleasy
//
//  Created by Miftahul Fazi on 28/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var splashFinished = false
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some View {
        Group {
            if !splashFinished {
                SplashView(isFinished: $splashFinished)
            } else if !isAuthenticated {
                AuthView(isAuthenticated: $isAuthenticated)
            } else {
                TabView {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house.fill") }

                    ExploreView()
                        .tabItem { Label("Explore", systemImage: "magnifyingglass") }

                    FavoritesView()
                        .tabItem { Label("Favorites", systemImage: "heart.fill") }

                    ProfileView()
                        .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

