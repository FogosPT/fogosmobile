import WidgetKit
import SwiftUI

struct NearbyCountEntry: TimelineEntry {
    let date: Date
    let count: Int
    let radiusKm: Int
    let topStatusHex: String
    let hasLocation: Bool
}

struct NearbyCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> NearbyCountEntry {
        NearbyCountEntry(date: Date(), count: 3, radiusKm: 50, topStatusHex: "#FF512F", hasLocation: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (NearbyCountEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NearbyCountEntry>) -> Void) {
        // We reload manually from the app; keep an entry that lasts 30 min
        // as a safety net so the widget still refreshes on its own.
        let entry = readEntry()
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: entry.date) ?? entry.date
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func readEntry() -> NearbyCountEntry {
        let d = UserDefaults(suiteName: "group.com.tomahock.fogos") ?? .standard
        let count = d.integer(forKey: "nearby_count")
        let radius = d.integer(forKey: "nearby_radius_km")
        let top = d.string(forKey: "nearby_top_status_hex") ?? "#FF512F"
        let hasLat = d.double(forKey: "nearby_lat") != 0
        return NearbyCountEntry(
            date: Date(),
            count: count,
            radiusKm: radius == 0 ? 50 : radius,
            topStatusHex: top,
            hasLocation: hasLat
        )
    }
}

struct NearbyCountEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: NearbyCountEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            circular
        case .accessoryCorner:
            corner
        case .accessoryRectangular:
            rectangular
        case .accessoryInline:
            inline
        default:
            circular
        }
    }

    private var accent: Color {
        color(hex: entry.topStatusHex)
    }

    private var circular: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(accent)
                    .font(.caption)
                Text("\(entry.count)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .monospacedDigit()
            }
        }
        .widgetLabel {
            Text("Fogos.pt · \(entry.radiusKm) km")
        }
    }

    private var corner: some View {
        Image(systemName: "flame.fill")
            .foregroundStyle(accent)
            .widgetLabel {
                Text("\(entry.count) fogos · \(entry.radiusKm) km")
            }
    }

    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(accent)
                Text(entry.hasLocation
                     ? "\(entry.count) fogos próximos"
                     : "\(entry.count) fogos ativos")
                    .font(.headline)
                    .lineLimit(1)
            }
            if entry.hasLocation {
                Text("dentro de \(entry.radiusKm) km")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text("sem localização")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text("Atualizado \(entry.date, style: .relative)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    private var inline: some View {
        Text("🔥 \(entry.count) fogos · \(entry.radiusKm) km")
    }
}

struct NearbyCountComplication: Widget {
    let kind: String = "NearbyCountComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NearbyCountProvider()) { entry in
            NearbyCountEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Fogos.pt")
        .description("Número de incêndios ativos dentro do teu raio configurado.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryRectangular, .accessoryInline])
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

#Preview("Circular", as: .accessoryCircular) {
    NearbyCountComplication()
} timeline: {
    NearbyCountEntry(date: .now, count: 3, radiusKm: 50, topStatusHex: "#FF512F", hasLocation: true)
    NearbyCountEntry(date: .now, count: 0, radiusKm: 50, topStatusHex: "#00A000", hasLocation: true)
}

#Preview("Rectangular", as: .accessoryRectangular) {
    NearbyCountComplication()
} timeline: {
    NearbyCountEntry(date: .now, count: 5, radiusKm: 25, topStatusHex: "#FF512F", hasLocation: true)
}
