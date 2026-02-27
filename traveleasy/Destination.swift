// Destination model and sample data with remote image URLs
import Foundation

struct Destination: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let region: String
    let overview: String
    let imageURL: URL?
    let symbol: String // keep symbol for fallback icons
}

let sampleDestinations: [Destination] = [
    Destination(
        name: "Bali",
        region: "Bali",
        overview: "Island of the Gods, famous for beaches, temples, culture, and vibrant cafes.",
        imageURL: URL(string: "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=1200&q=80&auto=format&fit=crop"),
        symbol: "sun.max.fill"
    ),
    Destination(
        name: "Yogyakarta",
        region: "Java",
        overview: "Cultural heart of Java with Borobudur & Prambanan temples and traditional arts.",
        imageURL: URL(string: "https://images.unsplash.com/photo-1583394838336-acd977736f90?w=1200&q=80&auto=format&fit=crop"),
        symbol: "building.columns"
    ),
    Destination(
        name: "Raja Ampat",
        region: "Papua",
        overview: "World-class diving paradise with pristine reefs and emerald islands.",
        imageURL: URL(string: "https://images.unsplash.com/photo-1544551763-7ef4200d2f59?w=1200&q=80&auto=format&fit=crop"),
        symbol: "tortoise.fill"
    ),
    Destination(
        name: "Komodo",
        region: "Nusa Tenggara",
        overview: "Home of the Komodo dragon, pink beaches, and dramatic island landscapes.",
        imageURL: URL(string: "https://images.unsplash.com/photo-1517824806704-9040b037703b?w=1200&q=80&auto=format&fit=crop"),
        symbol: "lizard.fill"
    )
]

