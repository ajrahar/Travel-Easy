import Combine
import Foundation
import SwiftUI

final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Destination] = []

    private let userDefaultsKey = "traveleasy.favorites"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func contains(_ destination: Destination) -> Bool {
        favorites.contains { $0.id == destination.id }
    }

    func add(_ destination: Destination) {
        guard !contains(destination) else { return }
        favorites.append(destination)
        save()
    }

    func remove(_ destination: Destination) {
        favorites.removeAll { $0.id == destination.id }
        save()
    }

    func toggle(_ destination: Destination) {
        if contains(destination) {
            remove(destination)
        } else {
            add(destination)
        }
    }

    private func load() {
        guard let data = defaults.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([Destination].self, from: data) else { return }
        favorites = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        defaults.set(data, forKey: userDefaultsKey)
    }
}
