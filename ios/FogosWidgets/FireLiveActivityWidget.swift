import ActivityKit
import SwiftUI
import WidgetKit

struct FireLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FireActivityAttributes.self) { context in
            // Lock screen / Smart Stack view
            FireLiveActivityLockScreen(
                attributes: context.attributes,
                state: context.state
            )
            .activityBackgroundTint(Color.black.opacity(0.4))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text(context.attributes.location)
                            .font(.caption)
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: context.attributes.isFire ? "flame.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(color(hex: context.state.statusColorHex))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    if let d = context.state.distanceKm {
                        Text(d < 1 ? "\(Int(d * 1000)) m" : "\(Int(d.rounded())) km")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.statusText)
                        .font(.headline)
                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    resourceRow(state: context.state)
                }
            } compactLeading: {
                Image(systemName: context.attributes.isFire ? "flame.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(color(hex: context.state.statusColorHex))
            } compactTrailing: {
                Text("\(context.state.human)")
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "flame.fill")
                    .foregroundStyle(color(hex: context.state.statusColorHex))
            }
        }
    }
}

private struct FireLiveActivityLockScreen: View {
    let attributes: FireActivityAttributes
    let state: FireActivityAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: attributes.isFire ? "flame.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(color(hex: state.statusColorHex))
                Text(attributes.location)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                if let d = state.distanceKm {
                    Text(d < 1 ? "\(Int(d * 1000)) m" : "\(Int(d.rounded())) km")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Text(state.statusText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            resourceRow(state: state)
                .font(.caption)
        }
        .padding(12)
    }
}

@ViewBuilder
private func resourceRow(state: FireActivityAttributes.ContentState) -> some View {
    HStack(spacing: 12) {
        Label("\(state.human)", systemImage: "person.fill")
        Label("\(state.terrain)", systemImage: "car.fill")
        Label("\(state.aerial)", systemImage: "airplane")
        Spacer()
        Text(state.updatedAt, style: .relative)
            .foregroundStyle(.tertiary)
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
