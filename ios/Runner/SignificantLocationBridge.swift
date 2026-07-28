import CoreLocation
import Flutter
import Foundation

/// Refreshes the stored nearby-alert location using Core Location's
/// Significant-Change service. Unlike a regular `CLLocationManager`, this
/// wakes the app in the background whenever the device moves ~500m or
/// changes cell tower — with negligible battery cost — so the on-device
/// proximity filter operates on a fresh position even for users who rarely
/// open the app. The last known coordinate is mirrored to the App Group so
/// the Notification Service Extension can read it without launching Flutter.
@objc final class SignificantLocationBridge: NSObject {
    @objc static let shared = SignificantLocationBridge()

    static let appGroup = "group.com.tomahock.fogos"
    static let kLat = "nearby_lat"
    static let kLng = "nearby_lng"
    static let kTs = "nearby_ts_ms"

    static let kRadiusKm = "nearby_radius_km"
    static let kEnabled = "nearby_enabled"
    static let kFilter = "nearby_filter"

    private let channelName = "pt.fogos/significant_location"
    private var channel: FlutterMethodChannel?
    private let manager: CLLocationManager
    private let delegate: SLDelegate

    override init() {
        manager = CLLocationManager()
        delegate = SLDelegate()
        super.init()
        manager.delegate = delegate
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.pausesLocationUpdatesAutomatically = false
    }

    @objc func register(withMessenger messenger: FlutterBinaryMessenger) {
        let ch = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel = ch
        ch.setMethodCallHandler { [weak self] call, result in
            self?.handle(call: call, result: result)
        }
        // If the app is launching in response to a significant-change wake,
        // the OS delivers the location via the delegate; nothing to do here.
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            start()
            result(true)
        case "stop":
            stop()
            result(true)
        case "getLast":
            result(readLast())
        case "mirrorSettings":
            let args = (call.arguments as? [String: Any]) ?? [:]
            mirrorSettings(args)
            result(true)
        case "writeLocation":
            let args = (call.arguments as? [String: Any]) ?? [:]
            if let lat = args["lat"] as? Double, let lng = args["lng"] as? Double {
                persist(CLLocation(latitude: lat, longitude: lng))
            }
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Copy nearby toggle/radius/filter into the App Group so the
    /// Notification Service Extension (out-of-process) reads the same
    /// values without touching the Flutter isolate.
    private func mirrorSettings(_ args: [String: Any]) {
        guard let defaults = UserDefaults(suiteName: Self.appGroup) else { return }
        if let enabled = args["enabled"] as? Bool {
            defaults.set(enabled, forKey: Self.kEnabled)
        }
        if let radius = args["radiusKm"] as? Int {
            defaults.set(radius, forKey: Self.kRadiusKm)
        }
        if let filter = args["filter"] as? String {
            defaults.set(filter, forKey: Self.kFilter)
        }
    }

    private func start() {
        guard CLLocationManager.significantLocationChangeMonitoringAvailable() else { return }
        // Do not prompt — permission is expected to be granted by the Flutter
        // side (permission_handler) before start() is invoked.
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        manager.startMonitoringSignificantLocationChanges()
    }

    private func stop() {
        manager.stopMonitoringSignificantLocationChanges()
    }

    private func readLast() -> [String: Any]? {
        guard let defaults = UserDefaults(suiteName: Self.appGroup) else { return nil }
        let lat = defaults.double(forKey: Self.kLat)
        let lng = defaults.double(forKey: Self.kLng)
        let ts = defaults.integer(forKey: Self.kTs)
        if lat == 0 && lng == 0 { return nil }
        return ["lat": lat, "lng": lng, "ts": ts]
    }

    fileprivate func persist(_ location: CLLocation) {
        guard let defaults = UserDefaults(suiteName: Self.appGroup) else { return }
        defaults.set(location.coordinate.latitude, forKey: Self.kLat)
        defaults.set(location.coordinate.longitude, forKey: Self.kLng)
        defaults.set(Int(Date().timeIntervalSince1970 * 1000), forKey: Self.kTs)
    }
}

private final class SLDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        SignificantLocationBridge.shared.persist(loc)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        NSLog("[SignificantLocationBridge] error: \(error)")
    }
}
