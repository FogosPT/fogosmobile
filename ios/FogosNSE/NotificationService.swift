// Fogos.pt — Notification Service Extension
//
// This extension runs *in its own process* whenever an APNs alert arrives
// with `mutable-content: 1`. It fires even if the Flutter app has been
// force-quit, which is the primary reason it exists: the previous "wake
// the app via silent push and run the geofence in Dart" flow is throttled
// aggressively by iOS and misses users who never open the app.
//
// What it does:
//   1. Reads the user's last known coordinate + radius from the App Group
//      shared UserDefaults (populated by SignificantLocationBridge and by
//      the Flutter settings screen).
//   2. Computes distance to the incident lat/lng carried in the APS payload.
//   3. Enriches the alert body ("🔥 Incêndio a 3 km") when within radius,
//      and promotes it to `interruptionLevel = .timeSensitive` so it
//      bypasses Focus / Do Not Disturb.
//   4. When outside the radius, leaves the alert as-is — the backend must
//      still be selective about broadcast fan-out (this extension cannot
//      truly suppress a notification; iOS always shows *something* once
//      the OS decides to display).
//
// Expected APS payload shape:
//   {
//     "aps": { "alert": {...}, "mutable-content": 1 },
//     "type": "nearby",
//     "lat": "40.1234",
//     "lng": "-8.5678",
//     "isFire": "1",
//     "fireId": "..."
//   }
//
// ---------------------------------------------------------------------------
// XCODE SETUP (one-off manual step — cannot be done from Flutter):
//   1. In Xcode: File → New → Target → "Notification Service Extension"
//        Product Name:  FogosNSE
//        Language:      Swift
//        Team:          same as Runner
//   2. Xcode will create a skeleton; DELETE the auto-generated
//      NotificationService.swift and drop THIS file into the new target's
//      folder in Xcode (it lives at ios/FogosNSE/NotificationService.swift).
//   3. Move the generated Info.plist aside and use the one already in this
//      folder (ios/FogosNSE/Info.plist).
//   4. Signing & Capabilities on the new target → add the App Group
//      "group.com.tomahock.fogos". Xcode will create FogosNSE.entitlements;
//      replace it with the one already committed here.
//   5. Deployment target: iOS 15.0+ (interruptionLevel API).
//   6. Runner target → Build Phases → Embed App Extensions → confirm
//      FogosNSE.appex is embedded.
// ---------------------------------------------------------------------------

import UserNotifications
import CoreLocation

final class NotificationService: UNNotificationServiceExtension {

    private static let appGroup = "group.com.tomahock.fogos"
    // Keys must match SignificantLocationBridge.swift and the Flutter side.
    private static let kLat = "nearby_lat"
    private static let kLng = "nearby_lng"
    private static let kRadiusKm = "nearby_radius_km"
    private static let kEnabled = "nearby_enabled"
    private static let kFilter = "nearby_filter"

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttempt: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        guard let mutable = request.content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(request.content)
            return
        }
        bestAttempt = mutable

        let userInfo = request.content.userInfo
        let type = (userInfo["type"] as? String) ?? ""
        guard type == "nearby" else {
            contentHandler(mutable)
            return
        }

        guard let defaults = UserDefaults(suiteName: Self.appGroup) else {
            contentHandler(mutable)
            return
        }

        let enabled = defaults.bool(forKey: Self.kEnabled)
        guard enabled else {
            contentHandler(mutable)
            return
        }

        let userLat = defaults.double(forKey: Self.kLat)
        let userLng = defaults.double(forKey: Self.kLng)
        guard userLat != 0 || userLng != 0 else {
            contentHandler(mutable)
            return
        }

        guard let lat = Self.readDouble(userInfo["lat"]),
              let lng = Self.readDouble(userInfo["lng"]) else {
            contentHandler(mutable)
            return
        }

        // Fires-only filter mirror from the app settings.
        let filter = (defaults.string(forKey: Self.kFilter)) ?? "fires"
        if filter == "fires" {
            let isFire = (userInfo["isFire"] as? String) ?? "0"
            if isFire != "1" {
                contentHandler(mutable)
                return
            }
        }

        let radiusKm = defaults.integer(forKey: Self.kRadiusKm)
        let effectiveRadius = radiusKm > 0 ? Double(radiusKm) : 50.0

        let userLoc = CLLocation(latitude: userLat, longitude: userLng)
        let fireLoc = CLLocation(latitude: lat, longitude: lng)
        let distanceKm = userLoc.distance(from: fireLoc) / 1000.0

        if distanceKm <= effectiveRadius {
            let distText: String
            if distanceKm < 1 {
                distText = "\(Int(round(distanceKm * 1000))) m"
            } else {
                distText = "\(Int(round(distanceKm))) km"
            }
            let isFire = ((userInfo["isFire"] as? String) ?? "0") == "1"
            let prefix = isFire ? "🔥" : "⚠️"
            mutable.title = "\(prefix) \(isFire ? "Incêndio" : "Incidente") a \(distText) de ti"
            if #available(iOS 15.0, *) {
                mutable.interruptionLevel = .timeSensitive
            }
            mutable.threadIdentifier = "nearby"
        }

        contentHandler(mutable)
    }

    override func serviceExtensionTimeWillExpire() {
        if let handler = contentHandler, let content = bestAttempt {
            handler(content)
        }
    }

    private static func readDouble(_ value: Any?) -> Double? {
        if let d = value as? Double { return d }
        if let s = value as? String { return Double(s) }
        if let n = value as? NSNumber { return n.doubleValue }
        return nil
    }
}
