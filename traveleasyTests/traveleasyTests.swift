//
//  traveleasyTests.swift
//  traveleasyTests
//
//  Created by Miftahul Fazi on 28/02/26.
//

import Testing
import Foundation
@testable import traveleasy

struct traveleasyTests {

    @Test func destinationHasStableId() throws {
        let d = sampleDestinations[0]
        #expect(d.id == "Bali|Bali" || d.id == "Yogyakarta|Java" || d.id == "Raja Ampat|Papua" || d.id == "Komodo|Nusa Tenggara")
        #expect(!d.id.isEmpty)
    }

    @Test func destinationIsCodableRoundTrip() throws {
        let d = sampleDestinations[0]
        let data = try JSONEncoder().encode(d)
        let decoded = try JSONDecoder().decode(Destination.self, from: data)
        #expect(decoded.id == d.id)
        #expect(decoded.name == d.name)
        #expect(decoded.region == d.region)
    }

    @Test func allRegionsMatchSampleData() throws {
        let regions = allRegions
        #expect(regions.count >= 1)
        for region in regions {
            let matches = sampleDestinations.contains { $0.region == region }
            #expect(matches, "Region '\(region)' not found in sampleDestinations")
        }
    }

    @Test func favoritesStoreAddRemoveContains() async throws {
        let defaults = UserDefaults(suiteName: "traveleasyTests")!
        defer { defaults.removePersistentDomain(forName: "traveleasyTests") }
        let store = FavoritesStore(defaults: defaults)
        let d = sampleDestinations[0]

        #expect(store.favorites.isEmpty)
        #expect(!store.contains(d))

        store.add(d)
        #expect(store.favorites.count == 1)
        #expect(store.contains(d))

        store.remove(d)
        #expect(store.favorites.isEmpty)
        #expect(!store.contains(d))
    }

    @Test func favoritesStoreToggle() async throws {
        let defaults = UserDefaults(suiteName: "traveleasyTests")!
        defer { defaults.removePersistentDomain(forName: "traveleasyTests") }
        let store = FavoritesStore(defaults: defaults)
        let d = sampleDestinations[0]

        store.toggle(d)
        #expect(store.contains(d))
        store.toggle(d)
        #expect(!store.contains(d))
    }

    @Test func favoritesStorePersistence() async throws {
        let defaults = UserDefaults(suiteName: "traveleasyTests")!
        defer { defaults.removePersistentDomain(forName: "traveleasyTests") }
        let d = sampleDestinations[0]
        let store1 = FavoritesStore(defaults: defaults)
        store1.add(d)
        #expect(store1.favorites.count == 1)

        let store2 = FavoritesStore(defaults: defaults)
        #expect(store2.favorites.count == 1)
        #expect(store2.contains(d))
    }
}
