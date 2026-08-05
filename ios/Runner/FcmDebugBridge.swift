import FirebaseMessaging
import Flutter
import Foundation

/// Small diagnostic bridge that calls FIRMessaging.token(completion:)
/// directly and returns the raw NSError (or the successful token) to
/// Dart. The firebase_messaging Flutter plugin wraps errors in a generic
/// "An unknown error has occurred" string, which is useless for
/// diagnosing why a device with a valid APNs token can't derive an FCM
/// token — the real reason (invalid APNs Auth Key Team ID / Key ID,
/// Firebase Cloud Messaging API disabled, revoked key, etc.) is only
/// visible in the underlying error.
@objc final class FcmDebugBridge: NSObject {
    @objc static let shared = FcmDebugBridge()

    private let channelName = "pt.fogos/fcm_debug"
    private var channel: FlutterMethodChannel?

    @objc func register(withMessenger messenger: FlutterBinaryMessenger) {
        let ch = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel = ch
        ch.setMethodCallHandler { [weak self] call, result in
            self?.handle(call: call, result: result)
        }
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "fetchToken":
            fetchToken(result: result)
        case "fetchApnsToken":
            fetchApnsToken(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func fetchToken(result: @escaping FlutterResult) {
        Messaging.messaging().token { token, error in
            var out: [String: Any] = [:]
            if let error = error as NSError? {
                out["error"] = error.localizedDescription
                out["domain"] = error.domain
                out["code"] = error.code
                if let underlying = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                    out["underlying"] = "\(underlying.domain)#\(underlying.code): \(underlying.localizedDescription)"
                }
                out["userInfo"] = error.userInfo.description
            }
            if let token = token, !token.isEmpty {
                out["token"] = token
            }
            result(out)
        }
    }

    private func fetchApnsToken(result: @escaping FlutterResult) {
        var out: [String: Any] = [:]
        if let token = Messaging.messaging().apnsToken {
            let hex = token.map { String(format: "%02x", $0) }.joined()
            out["apnsToken"] = hex
            out["length"] = token.count
        }
        out["sandbox"] = { () -> String in
            #if DEBUG
            return "yes"
            #else
            return "no"
            #endif
        }()
        result(out)
    }
}
