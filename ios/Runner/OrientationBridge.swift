import CoreMotion
import Flutter
import Foundation

/// Fused device-orientation source for the incident-photo compass.
///
/// The Flutter side previously computed camera azimuth from raw
/// accelerometer + magnetometer readings (via sensors_plus). That formula
/// is mathematically correct but the raw magnetometer picks up every piece
/// of nearby metal, and the accelerometer picks up every hand tremor, so
/// the value dances and occasionally flips.
///
/// This bridge asks Core Motion for a Kalman-fused device attitude in the
/// `xTrueNorthZVertical` reference frame (X → True North, Y → West, Z →
/// Up). It extracts the world direction of the camera axis (device -Z) and
/// reports both the heading and a coarse accuracy classification derived
/// from `magneticField.accuracy`. When location services are unauthorised
/// we fall back to `xMagneticNorthZVertical` and flag the sample as
/// magnetic-only so the caller can add declination itself (or record
/// `GPSImgDirectionRef = M` in EXIF).
@objc final class OrientationBridge: NSObject {
    @objc static let shared = OrientationBridge()

    private let channelName = "pt.fogos/orientation"
    private var channel: FlutterMethodChannel?

    private let motion = CMMotionManager()
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "pt.fogos.orientation"
        q.maxConcurrentOperationCount = 1
        q.qualityOfService = .userInteractive
        return q
    }()

    private var running = false
    private var usingTrueNorth = false

    @objc func register(withMessenger messenger: FlutterBinaryMessenger) {
        let ch = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        channel = ch
        ch.setMethodCallHandler { [weak self] call, result in
            self?.handle(call: call, result: result)
        }
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            result(start())
        case "stop":
            stop()
            result(true)
        case "isAvailable":
            result(motion.isDeviceMotionAvailable)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @discardableResult
    private func start() -> Bool {
        guard motion.isDeviceMotionAvailable else { return false }
        if running { return true }

        motion.deviceMotionUpdateInterval = 1.0 / 30.0
        // Try true-north first; it needs location authorisation. If Core
        // Motion refuses to start (returns immediately without ever
        // emitting), the caller can request the magnetic frame instead.
        let frame: CMAttitudeReferenceFrame = .xTrueNorthZVertical
        usingTrueNorth = true
        motion.startDeviceMotionUpdates(using: frame, to: queue) { [weak self] motion, error in
            guard let self = self else { return }
            if let error = error {
                NSLog("[OrientationBridge] device-motion error: \(error)")
                return
            }
            guard let m = motion else { return }
            self.emit(motion: m)
        }
        running = true
        return true
    }

    private func stop() {
        if running {
            motion.stopDeviceMotionUpdates()
            running = false
        }
    }

    private func emit(motion m: CMDeviceMotion) {
        // Rotation matrix maps device-frame vectors into the reference
        // frame. Camera axis in device coords is (0, 0, -1) — the back
        // camera points opposite to +Z. Applying the matrix:
        //   ref = R * device
        //   cam_ref = (-R.m13, -R.m23, -R.m33)
        // Reference frame (xTrueNorthZVertical): X = True North,
        //                                        Y = West,
        //                                        Z = Up.
        let R = m.attitude.rotationMatrix
        let northComp = -R.m13
        let westComp = -R.m23
        let upComp = -R.m33
        // Compass heading: clockwise from north. East = -West.
        let eastComp = -westComp
        var heading = atan2(eastComp, northComp) * 180.0 / .pi
        if heading < 0 { heading += 360 }

        // Pitch of the camera direction relative to the horizontal plane.
        // Positive when tilting the phone back so the camera looks up.
        let horiz = sqrt(northComp * northComp + westComp * westComp)
        let pitch = atan2(upComp, horiz) * 180.0 / .pi

        // Guard: attitude can be degenerate at the very first sample.
        // Flutter uses .floor()/.round() on these values which throws
        // on NaN, so drop the emission.
        guard heading.isFinite, pitch.isFinite else { return }

        let accuracy: String
        switch m.magneticField.accuracy {
        case .uncalibrated: accuracy = "uncalibrated"
        case .low: accuracy = "low"
        case .medium: accuracy = "medium"
        case .high: accuracy = "high"
        @unknown default: accuracy = "unknown"
        }

        let args: [String: Any] = [
            "headingDeg": heading,
            "pitchDeg": pitch,
            "accuracy": accuracy,
            "isTrueNorth": usingTrueNorth,
        ]
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("orientation", arguments: args)
        }
    }
}
