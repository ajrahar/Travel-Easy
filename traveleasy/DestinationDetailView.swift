import SwiftUI

struct DestinationDetailView: View {
    let destination: Destination
    @EnvironmentObject var favoritesStore: FavoritesStore

    private var isFavorite: Bool { favoritesStore.contains(destination) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.Spacing.relaxed) {
                DestinationImage(
                    url: destination.imageURL,
                    symbol: destination.symbol,
                    height: Layout.Image.detailHeight,
                    cornerRadius: Layout.CornerRadius.large
                )

                Text(destination.name).font(.largeTitle.bold())
                Text(destination.region).font(.title3).foregroundStyle(.secondary)
                Text("Overview").font(.headline)
                Text(destination.overview)
            }
            .padding()
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    favoritesStore.toggle(destination)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .red : .primary)
                }
                .accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                .accessibilityHint("Double tap to \(isFavorite ? "remove from" : "add to") favorites")
            }
        }
    }
}
