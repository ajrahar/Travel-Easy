import SwiftUI

struct ExploreView: View {
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            List {
                if query.isEmpty {
                    Section(L10n.browseByRegion) {
                        ForEach(allRegions, id: \.self) { region in
                            NavigationLink(destination: RegionDetailView(region: region)) {
                                Label(region, systemImage: "map")
                            }
                        }
                    }
                } else {
                    Section(L10n.results) {
                        ForEach(sampleDestinations.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.region.localizedCaseInsensitiveContains(query) }) { destination in
                            NavigationLink(destination: DestinationDetailView(destination: destination)) {
                                DestinationRow(destination: destination)
                            }
                        }
                    }
                }
            }
            .navigationTitle(L10n.tabExplore)
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: L10n.searchPrompt)
        }
    }
}
