import SwiftUI

struct NearbyListView: View {
    @State private var vm = FiresViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.fires.isEmpty {
                    ProgressView()
                } else if let error = vm.errorMessage, vm.fires.isEmpty {
                    ContentUnavailableView(error, systemImage: "wifi.exclamationmark")
                } else if vm.fires.isEmpty {
                    ContentUnavailableView(
                        "Sem incêndios",
                        systemImage: "checkmark.circle",
                        description: Text(vm.userLat == nil
                            ? "Sem localização ainda — a mostrar todos ativos"
                            : "Nenhum dentro de \(vm.radiusKm) km")
                    )
                } else {
                    List {
                        if let stats = vm.nowStats {
                            NowStatsHeader(stats: stats)
                                .listRowBackground(Color.clear)
                        }
                        ForEach(vm.fires) { fire in
                            NavigationLink(value: fire) {
                                FireRow(fire: fire, userLat: vm.userLat, userLng: vm.userLng)
                            }
                        }
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Fogos.pt")
            .navigationDestination(for: Fire.self) { fire in
                FireDetailView(fire: fire, userLat: vm.userLat, userLng: vm.userLng)
            }
            .task {
                // Refresh loop: reload on view appear, then every 60s while
                // this view stays visible. Cancels automatically when the
                // task is torn down (tab change, app backgrounded).
                await vm.load()
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(60))
                    if Task.isCancelled { break }
                    await vm.load()
                }
            }
            .refreshable { await vm.load() }
            .onReceive(NotificationCenter.default.publisher(for: WatchSessionManager.didUpdatePrefs)) { _ in
                Task { await vm.load() }
            }
        }
    }
}

struct NowStatsHeader: View {
    let stats: NowStats

    var body: some View {
        HStack(spacing: 8) {
            stat(icon: "person.fill", value: stats.man)
            stat(icon: "car.fill", value: stats.cars)
            stat(icon: "airplane", value: stats.aerial)
        }
        .font(.caption2)
    }

    private func stat(icon: String, value: Int) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
            Text("\(value)")
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }
}

struct FireRow: View {
    let fire: Fire
    let userLat: Double?
    let userLng: Double?

    var distanceText: String? {
        guard let userLat, let userLng else { return nil }
        let d = fire.distanceKm(from: userLat, userLng)
        return d < 1 ? "\(Int(d * 1000)) m" : "\(Int(d.rounded())) km"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(fire.isFire ? "🔥" : "⚠️")
                Text(fire.city.isEmpty ? fire.district : fire.city)
                    .font(.headline)
                    .lineLimit(1)
                if let distanceText {
                    Spacer()
                    Text(distanceText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Text(fire.statusText.isEmpty ? fire.nature : fire.statusText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            HStack(spacing: 8) {
                Label("\(fire.human)", systemImage: "person.fill")
                Label("\(fire.terrain)", systemImage: "car.fill")
                Label("\(fire.aerial)", systemImage: "airplane")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NearbyListView()
}
