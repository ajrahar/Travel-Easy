import SwiftUI

struct DestinationImage: View {
    let url: URL?
    let symbol: String
    var width: CGFloat? = nil
    var height: CGFloat
    var cornerRadius: CGFloat = Layout.CornerRadius.large
    @ScaledMetric(relativeTo: .body) private var fallbackIconSize: CGFloat = 48
    @State private var retryId = 0

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.2))
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.2))
                    VStack(spacing: 8) {
                        Image(systemName: symbol)
                            .font(.system(size: min(height * 0.25, fallbackIconSize)))
                            .foregroundStyle(.secondary)
                        Button("Retry") { retryId += 1 }
                            .font(.caption)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Image failed to load. Retry.")
                .accessibilityHint("Double tap to retry loading the image")
            @unknown default:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .id("\(url?.absoluteString ?? "")-\(retryId)")
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
