import SwiftUI

struct RegionDetailView: View {
    let region: String

    var body: some View {
        List(sampleDestinations.filter { $0.region == region }) { destination in
            NavigationLink(destination: DestinationDetailView(destination: destination)) {
                DestinationRow(destination: destination)
            }
        }
        .navigationTitle(region)
    }
}
