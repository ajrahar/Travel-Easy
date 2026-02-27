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
                                AsyncImage(url: destination.imageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ZStack { Color.gray.opacity(0.2); ProgressView() }
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        ZStack {
                                            Color.gray.opacity(0.2)
                                            Image(systemName: destination.symbol)
                                                .font(.system(size: 48))
                                                .foregroundStyle(.secondary)
                                        }
                                    @unknown default:
                                        Color.gray.opacity(0.2)
                                    }
                                }
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                                LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .frame(height: 200)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(destination.name)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(destination.region)
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                .padding()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .frame(height: 220)
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
