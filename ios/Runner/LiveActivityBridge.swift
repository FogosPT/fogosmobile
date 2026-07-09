import Foundation
import Flutter

#if canImport(ActivityKit)
import ActivityKit
#endif

/// Bridges Flutter → ActivityKit for the "seguir incêndio" feature.
/// One activity per followed fireId. Started with `start`, refreshed with
/// `update`, ended with `stop`. Requires iOS 16.1+; silently no-ops otherwise.
@objc final class LiveActivityBridge: NSObject {
    @objc static let shared = LiveActivityBridge()

    private let channelName = "pt.fogos/live_activity"
    private var channel: FlutterMethodChannel?

    @objc func register(withMessenger messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        self.channel = channel
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call: call, result: result)
        }
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        #if canImport(ActivityKit)
        guard #available(iOS 16.2, *) else {
            result(false)
            return
        }
        guard let args = call.arguments as? [String: Any],
              let fireId = args["fireId"] as? String, !fireId.isEmpty else {
            result(FlutterError(code: "bad_args", message: "fireId required", details: nil))
            return
        }
        switch call.method {
        case "start":
            let ok = start(fireId: fireId, args: args)
            result(ok)
        case "update":
            update(fireId: fireId, args: args)
            result(nil)
        case "stop":
            Task { await stop(fireId: fireId); result(nil) }
        case "isActive":
            result(isActive(fireId: fireId))
        default:
            result(FlutterMethodNotImplemented)
        }
        #else
        result(false)
        #endif
    }

    #if canImport(ActivityKit)
    @available(iOS 16.2, *)
    private func start(fireId: String, args: [String: Any]) -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return false }

        let attributes = FireActivityAttributes(
            fireId: fireId,
            location: (args["location"] as? String) ?? "",
            isFire: (args["isFire"] as? Bool) ?? true
        )
        let state = contentState(from: args)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(60 * 60))

        do {
            _ = try Activity.request(attributes: attributes, content: content, pushType: nil)
            return true
        } catch {
            NSLog("[LiveActivityBridge] start failed: \(error)")
            return false
        }
    }

    @available(iOS 16.2, *)
    private func update(fireId: String, args: [String: Any]) {
        guard let activity = Activity<FireActivityAttributes>.activities
            .first(where: { $0.attributes.fireId == fireId }) else { return }
        let state = contentState(from: args)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(60 * 60))
        Task { await activity.update(content) }
    }

    @available(iOS 16.2, *)
    private func stop(fireId: String) async {
        for activity in Activity<FireActivityAttributes>.activities
            where activity.attributes.fireId == fireId {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    @available(iOS 16.2, *)
    private func isActive(fireId: String) -> Bool {
        Activity<FireActivityAttributes>.activities
            .contains { $0.attributes.fireId == fireId }
    }

    @available(iOS 16.2, *)
    private func contentState(from args: [String: Any]) -> FireActivityAttributes.ContentState {
        FireActivityAttributes.ContentState(
            statusText: (args["statusText"] as? String) ?? "",
            statusColorHex: (args["statusColorHex"] as? String) ?? "#FF0000",
            human: (args["human"] as? Int) ?? 0,
            terrain: (args["terrain"] as? Int) ?? 0,
            aerial: (args["aerial"] as? Int) ?? 0,
            distanceKm: args["distanceKm"] as? Double,
            updatedAt: Date()
        )
    }
    #endif
}
