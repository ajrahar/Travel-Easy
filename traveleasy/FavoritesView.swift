import SwiftUI

struct FavoritesView: View {
    // Placeholder favorites
    @State private var favorites: [Destination] = []

    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Save places you love to find them quickly."))
                } else {
                    List(favorites) { destination in
                        DestinationRow(destination: destination)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
