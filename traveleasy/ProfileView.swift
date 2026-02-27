import SwiftUI

struct ProfileView: View {
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @AppStorage("storedName") private var storedName: String = ""
    @AppStorage("storedEmail") private var storedEmail: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle().fill(.blue.opacity(0.15))
                            Image(systemName: "person.crop.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.blue)
                        }
                        .frame(width: 64, height: 64)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(storedName.isEmpty ? "Guest" : storedName)
                                .font(.headline)
                            Text(storedEmail.isEmpty ? "Not signed in" : storedEmail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Account") {
                    if isAuthenticated {
                        Button(role: .destructive) {
                            isAuthenticated = false
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } else {
                        Label("Please sign in from the Home screen", systemImage: "person.badge.plus")
                    }
                    Label("Language: Bahasa/English", systemImage: "globe")
                }

                Section("About Indonesia") {
                    Label("Travel Tips", systemImage: "lightbulb")
                    Label("Cultural Etiquette", systemImage: "hand.raised")
                    Label("Emergency Numbers", systemImage: "phone")
                }
                
                Section("Emergency Numbers (Indonesia)") {
                    EmergencyRow(label: "General Emergency (where available)", number: "112", systemImage: "phone.fill")
                    EmergencyRow(label: "Police", number: "110", systemImage: "shield.fill")
                    EmergencyRow(label: "Ambulance / Medical", number: "118", systemImage: "cross.case.fill")
                    EmergencyRow(label: "Ambulance (alternative)", number: "119", systemImage: "cross.case")
                    EmergencyRow(label: "Fire Department", number: "113", systemImage: "flame.fill")
                    EmergencyRow(label: "Search & Rescue (BASARNAS)", number: "115", systemImage: "lifepreserver.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
struct EmergencyRow: View {
    let label: String
    let number: String
    let systemImage: String

    var body: some View {
        Button(action: call) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundStyle(.red)
                VStack(alignment: .leading) {
                    Text(label)
                    Text(number).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.tertiary)
            }
        }
        .buttonStyle(.plain)
    }

    private func call() {
        guard let url = URL(string: "tel://\(number)") else { return }
        UIApplication.shared.open(url)
    }
}

