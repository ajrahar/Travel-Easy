import SwiftUI

struct ExploreView: View {
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            List {
                if query.isEmpty {
                    Section("Browse by Region") {
                        ForEach(["Sumatra", "Java", "Bali & Nusa Tenggara", "Kalimantan", "Sulawesi", "Papua"], id: \.self) { region in
                            NavigationLink(destination: RegionDetailView(region: region)) {
                                Label(region, systemImage: "map")
                            }
                        }
                    }
                } else {
                    Section("Results") {
                        ForEach(sampleDestinations.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.region.localizedCaseInsensitiveContains(query) }) { destination in
                            NavigationLink(destination: DestinationDetailView(destination: destination)) {
                                DestinationRow(destination: destination)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search destinations, food, culture…")
        }
    }
}
