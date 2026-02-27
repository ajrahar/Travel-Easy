import SwiftUI

struct DestinationRow: View {
    let destination: Destination

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.blue.opacity(0.08))
                    .frame(width: 64, height: 64)
                AsyncImage(url: destination.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: destination.symbol)
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                            .foregroundStyle(.blue)
                    @unknown default:
                        Image(systemName: destination.symbol)
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                            .foregroundStyle(.blue)
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(destination.name).font(.headline)
                Text(destination.region).font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
}
