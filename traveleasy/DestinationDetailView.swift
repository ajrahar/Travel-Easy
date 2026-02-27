import SwiftUI

struct DestinationDetailView: View {
    let destination: Destination

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: destination.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 16).fill(.blue.opacity(0.08))
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 16).fill(.blue.opacity(0.08))
                            Image(systemName: destination.symbol)
                                .font(.system(size: 64))
                                .foregroundStyle(.blue)
                        }
                    @unknown default:
                        Color.clear
                    }
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(destination.name).font(.largeTitle.bold())
                Text(destination.region).font(.title3).foregroundStyle(.secondary)
                Text("Overview").font(.headline)
                Text(destination.overview)
            }
            .padding()
        }
        .navigationTitle(destination.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
