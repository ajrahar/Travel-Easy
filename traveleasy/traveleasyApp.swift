//
//  traveleasyApp.swift
//  traveleasy
//
//  Created by Miftahul Fazi on 28/02/26.
//

import SwiftUI

@main
struct traveleasyApp: App {
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
    }
}
