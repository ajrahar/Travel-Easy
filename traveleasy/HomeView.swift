import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                // Carousel Banner
                Section {
                    TabView {
                        ForEach(sampleDestinations.prefix(4)) { destination in
                            ZStack(alignment: .bottomLeading) {
                                DestinationImage(
                                    url: destination.imageURL,
                                    symbol: destination.symbol,
                                    height: Layout.Image.carouselHeight,
                                    cornerRadius: Layout.CornerRadius.large
                                )

                                LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                                    .clipShape(RoundedRectangle(cornerRadius: Layout.CornerRadius.large, style: .continuous))
                                    .frame(height: Layout.Image.carouselHeight)

                                VStack(alignment: .leading, spacing: Layout.Spacing.tight) {
                                    Text(destination.name)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(destination.region)
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                .padding()
                            }
                            .padding(.vertical, Layout.Spacing.tight)
                        }
                    }
                    .frame(height: Layout.Image.carouselContainerHeight)
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .listRowInsets(EdgeInsets())
                }

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
