import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    Label("Sign in", systemImage: "person.crop.circle.badge.plus")
                    Label("Language: Bahasa/English", systemImage: "globe")
                }

                Section("About Indonesia") {
                    Label("Travel Tips", systemImage: "lightbulb")
                    Label("Cultural Etiquette", systemImage: "hand.raised")
                    Label("Emergency Numbers", systemImage: "phone")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
