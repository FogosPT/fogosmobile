import Foundation
import WidgetKit
import WatchKit

/// Fetches fires + publishes the complication snapshot without any UI.
/// Used by the SwiftUI `.backgroundTask(.appRefresh(...))` handler.
/// Kept as a static entry point so it can run when the app isn't holding
/// a live `FiresViewModel`.
enum BackgroundRefreshService {
    static let taskIdentifier = "pt.fogos.watch.refresh"

    /// Fetches fires, applies the user's radius/filter, and writes the
    /// summary the complication reads. Returns silently on failure so a
    /// stale snapshot survives temporary network issues.
    static func performRefresh() async {
        do {
            let all = try await FogosAPI.shared.fetchFires()
            let filtered = filterAndSort(all)
            let top = filtered.first
            let hex = (top?.statusColor.isEmpty == false ? top!.statusColor : "#FF512F")
            WatchPrefs.shared.publishNearbySnapshot(count: filtered.count, topStatusHex: hex)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            NSLog("[BackgroundRefresh] fetch failed: \(error)")
        }
    }

    /// Ask the system to wake us again in ~15 min for another refresh.
    /// watchOS caps the actual cadence (~4 wakes/hour). Idempotent.
    static func scheduleNext(after seconds: TimeInterval = 15 * 60) {
        let when = Date().addingTimeInterval(seconds)
        WKApplication.shared().scheduleBackgroundRefresh(
            withPreferredDate: when,
            userInfo: nil
        ) { error in
            if let error {
                NSLog("[BackgroundRefresh] schedule failed: \(error)")
            }
        }
    }

    // MARK: - Private

    private static func filterAndSort(_ input: [Fire]) -> [Fire] {
        let userLat = WatchPrefs.shared.lat
        let userLng = WatchPrefs.shared.lng
        let radius = Double(WatchPrefs.shared.radiusKm)
        let firesOnly = WatchPrefs.shared.firesOnly

        let filtered = input.filter { fire in
            guard fire.active else { return false }
            if firesOnly && !fire.isFire { return false }
            return true
        }
        guard let userLat, let userLng else {
            return filtered.sorted { $0.dateTimeSec > $1.dateTimeSec }
        }
        return filtered
            .map { (fire: $0, dist: $0.distanceKm(from: userLat, userLng)) }
            .filter { $0.dist <= radius }
            .sorted { $0.dist < $1.dist }
            .map { $0.fire }
    }
}
