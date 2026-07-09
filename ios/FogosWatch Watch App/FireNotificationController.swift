import SwiftUI
import UserNotifications
import WatchKit

/// Hosts `FireNotificationView` for the watchOS "long look" notification.
/// The system passes the incoming `UNNotification`; we forward it into
/// SwiftUI. Only triggers when the APS `category` matches the registered
/// scene ("fogos-fire"); other categories fall back to the system UI.
final class FireNotificationController: WKUserNotificationHostingController<FireNotificationView> {
    private var currentNotification: UNNotification?

    override var body: FireNotificationView {
        FireNotificationView(notification: currentNotification)
    }

    override func didReceive(_ notification: UNNotification) {
        currentNotification = notification
    }
}
