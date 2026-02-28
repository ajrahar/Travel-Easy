import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore

    var body: some View {
        NavigationStack {
            Group {
                if favoritesStore.favorites.isEmpty {
                    ContentUnavailableView(L10n.noFavoritesYet, systemImage: "heart", description: Text(L10n.noFavoritesDescription))
                } else {
                    List(favoritesStore.favorites) { destination in
                        NavigationLink(destination: DestinationDetailView(destination: destination)) {
                            DestinationRow(destination: destination)
                        }
                    }
                }
            }
            .navigationTitle(L10n.tabFavorites)
        }
    }
}
