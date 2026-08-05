import Foundation

/// Preferences shared between the iOS app and the watch via the App Group.
/// The iOS app writes these values through the WatchConnectivity bridge;
/// on watch they are read only.
final class WatchPrefs {
    static let shared = WatchPrefs()

    private let suiteName = "group.com.tomahock.fogos"
    private let defaults: UserDefaults

    private enum Keys {
        static let lat = "nearby_lat"
        static let lng = "nearby_lng"
        static let radiusKm = "nearby_radius_km"
        static let filter = "nearby_filter" // "fires" or "all"
        static let subscribedFires = "subscribed_fires"
        static let nearbyCount = "nearby_count"
        static let topStatusHex = "nearby_top_status_hex"
    }

    private init() {
        defaults = UserDefaults(suiteName: suiteName) ?? .standard
    }

    var lat: Double? {
        let v = defaults.double(forKey: Keys.lat)
        return v == 0 ? nil : v
    }

    var lng: Double? {
        let v = defaults.double(forKey: Keys.lng)
        return v == 0 ? nil : v
    }

    var radiusKm: Int {
        let v = defaults.integer(forKey: Keys.radiusKm)
        return v == 0 ? 50 : v
    }

    var firesOnly: Bool {
        (defaults.string(forKey: Keys.filter) ?? "fires") == "fires"
    }

    var subscribedFires: [String] {
        defaults.stringArray(forKey: Keys.subscribedFires) ?? []
    }

    func update(lat: Double?, lng: Double?, radiusKm: Int?, filter: String?, subscribedFires: [String]?) {
        if let lat { defaults.set(lat, forKey: Keys.lat) }
        if let lng { defaults.set(lng, forKey: Keys.lng) }
        if let radiusKm { defaults.set(radiusKm, forKey: Keys.radiusKm) }
        if let filter { defaults.set(filter, forKey: Keys.filter) }
        if let subscribedFires { defaults.set(subscribedFires, forKey: Keys.subscribedFires) }
    }

    /// Publish the counts the complication renders.
    /// Uses the most severe (first) fire's status color as the accent.
    func publishNearbySnapshot(count: Int, topStatusHex: String) {
        defaults.set(count, forKey: Keys.nearbyCount)
        defaults.set(topStatusHex, forKey: Keys.topStatusHex)
    }
}
