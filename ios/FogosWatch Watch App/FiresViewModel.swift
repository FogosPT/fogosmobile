import Foundation
import Observation
import WidgetKit

@Observable
@MainActor
final class FiresViewModel {
    var fires: [Fire] = []
    var nowStats: NowStats?
    var isLoading = false
    var errorMessage: String?

    var userLat: Double? {
        WatchPrefs.shared.lat
    }
    var userLng: Double? {
        WatchPrefs.shared.lng
    }
    var radiusKm: Int {
        WatchPrefs.shared.radiusKm
    }
    var firesOnly: Bool {
        WatchPrefs.shared.firesOnly
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        async let firesTask = FogosAPI.shared.fetchFires()
        async let statsTask = try? await FogosAPI.shared.fetchNowStats()
        do {
            let all = try await firesTask
            fires = filterAndSort(all)
            nowStats = await statsTask
        } catch {
            errorMessage = "Sem ligação"
            nowStats = await statsTask
        }
        publishComplicationSnapshot()
    }

    private func publishComplicationSnapshot() {
        let top = fires.first
        let hex = top?.statusColor.isEmpty == false ? top!.statusColor : "#FF512F"
        WatchPrefs.shared.publishNearbySnapshot(count: fires.count, topStatusHex: hex)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func filterAndSort(_ input: [Fire]) -> [Fire] {
        let filtered = input.filter { fire in
            guard fire.active else { return false }
            if firesOnly && !fire.isFire { return false }
            return true
        }
        guard let lat = userLat, let lng = userLng else {
            return filtered.sorted { $0.dateTimeSec > $1.dateTimeSec }
        }
        let radius = Double(radiusKm)
        return filtered
            .map { (fire: $0, dist: $0.distanceKm(from: lat, lng)) }
            .filter { $0.dist <= radius }
            .sorted { $0.dist < $1.dist }
            .map { $0.fire }
    }
}
