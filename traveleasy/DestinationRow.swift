import SwiftUI

struct DestinationRow: View {
    let destination: Destination

    var body: some View {
        HStack(spacing: Layout.Spacing.normal) {
            DestinationImage(
                url: destination.imageURL,
                symbol: destination.symbol,
                width: Layout.Image.rowSize,
                height: Layout.Image.rowSize,
                cornerRadius: Layout.CornerRadius.small
            )
            VStack(alignment: .leading) {
                Text(destination.name).font(.headline)
                Text(destination.region).font(.subheadline).foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(destination.name), \(destination.region)")
        }
    }
}
