import Foundation
import WatchConnectivity

/// Receives preferences and location from the paired iPhone via WCSession
/// and persists them in the App Group so `WatchPrefs` can serve them
/// synchronously. Posts a notification when new data arrives so any live
/// view can refresh.
final class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()

    /// Posted after applicationContext is applied to UserDefaults.
    static let didUpdatePrefs = Notification.Name("FogosWatchDidUpdatePrefs")

    private override init() {}

    func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
        apply(session.receivedApplicationContext)
    }

    private func apply(_ context: [String: Any]) {
        guard !context.isEmpty else { return }
        WatchPrefs.shared.update(
            lat: context["lat"] as? Double,
            lng: context["lng"] as? Double,
            radiusKm: context["radiusKm"] as? Int,
            filter: context["filter"] as? String,
            subscribedFires: context["subscribedFires"] as? [String]
        )
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.didUpdatePrefs, object: nil)
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if activationState == .activated {
            apply(session.receivedApplicationContext)
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        apply(applicationContext)
    }
}
