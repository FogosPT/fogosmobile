import SwiftUI
import UserNotifications

/// SwiftUI "long look" for an incoming fire notification pushed via APNs.
/// Reads title/body from `UNNotification` and enriches with data payload
/// (fireId, location, statusColor, meios) when the backend supplies them.
struct FireNotificationView: View {
    let notification: UNNotification?

    private var title: String {
        notification?.request.content.title ?? "🔥 Incêndio"
    }

    private var body_: String {
        notification?.request.content.body ?? ""
    }

    private var userInfo: [AnyHashable: Any] {
        notification?.request.content.userInfo ?? [:]
    }

    private var location: String {
        (userInfo["location"] as? String) ?? ""
    }

    private var statusText: String {
        (userInfo["status"] as? String) ?? ""
    }

    private var statusColorHex: String {
        (userInfo["statusColor"] as? String) ?? "#FF512F"
    }

    private var human: String {
        stringOrInt("man") ?? stringOrInt("human") ?? "-"
    }

    private var terrain: String {
        stringOrInt("terrain") ?? stringOrInt("cars") ?? "-"
    }

    private var aerial: String {
        stringOrInt("aerial") ?? "-"
    }

    private var isFire: Bool {
        let v = userInfo["isFire"]
        if let s = v as? String { return s == "true" || s == "1" }
        if let b = v as? Bool { return b }
        if let i = v as? Int { return i == 1 }
        return true
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: isFire ? "flame.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(color(hex: statusColorHex))
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
            }
            if !location.isEmpty {
                Text(location)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            } else if !body_.isEmpty {
                Text(body_)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            if !statusText.isEmpty {
                Text(statusText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Divider()
            HStack(spacing: 12) {
                Label(human, systemImage: "person.fill")
                Label(terrain, systemImage: "car.fill")
                Label(aerial, systemImage: "airplane")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }

    private func stringOrInt(_ key: String) -> String? {
        if let s = userInfo[key] as? String, !s.isEmpty { return s }
        if let i = userInfo[key] as? Int { return String(i) }
        return nil
    }
}

private func color(hex: String) -> Color {
    var hex = hex
    if hex.hasPrefix("#") { hex.removeFirst() }
    guard hex.count == 6, let value = UInt32(hex, radix: 16) else { return .red }
    let r = Double((value >> 16) & 0xFF) / 255
    let g = Double((value >> 8) & 0xFF) / 255
    let b = Double(value & 0xFF) / 255
    return Color(red: r, green: g, blue: b)
}
