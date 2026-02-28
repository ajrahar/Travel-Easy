//
//  ContentView.swift
//  traveleasy
//
//  Created by Miftahul Fazi on 28/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var splashFinished = false
    @AppStorage(AppStorageKeys.isAuthenticated) private var isAuthenticated: Bool = false
    
    var body: some View {
        Group {
            if !splashFinished {
                SplashView(isFinished: $splashFinished)
            } else if !isAuthenticated {
                AuthView(isAuthenticated: $isAuthenticated)
            } else {
                TabView {
                    HomeView()
                        .tabItem { Label(L10n.tabHome, systemImage: "house.fill") }

                    ExploreView()
                        .tabItem { Label(L10n.tabExplore, systemImage: "magnifyingglass") }

                    FavoritesView()
                        .tabItem { Label(L10n.tabFavorites, systemImage: "heart.fill") }

                    ProfileView()
                        .tabItem { Label(L10n.tabProfile, systemImage: "person.crop.circle") }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
}

