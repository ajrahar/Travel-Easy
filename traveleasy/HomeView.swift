import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Featured Destinations") {
                    ForEach(sampleDestinations.prefix(3)) { destination in
                        NavigationLink(destination: DestinationDetailView(destination: destination)) {
                            DestinationRow(destination: destination)
                        }
                    }
                }

                Section("Popular Experiences") {
                    ExperienceRow(title: "Temple Tours", subtitle: "Borobudur, Prambanan")
                    ExperienceRow(title: "Diving & Snorkeling", subtitle: "Raja Ampat, Bunaken")
                    ExperienceRow(title: "Culinary", subtitle: "Rendang, Sate, Nasi Goreng")
                }
            }
            .navigationTitle("TravelEasy 🇮🇩")
        }
    }
}
