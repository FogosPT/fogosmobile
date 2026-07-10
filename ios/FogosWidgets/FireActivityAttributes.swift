import Foundation

#if canImport(ActivityKit)
import ActivityKit

/// Attributes for a "seguir incêndio" Live Activity.
/// The fireId is fixed at start (attributes.state), everything else can
/// change over the lifetime of the activity (contentState).
public struct FireActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var statusText: String
        public var statusColorHex: String
        public var human: Int
        public var terrain: Int
        public var aerial: Int
        public var distanceKm: Double?
        /// Unix timestamp (seconds since 1970). Kept as a Double so the
        /// backend can encode it plainly in JSON without Date-format quirks.
        public var updatedAt: Double

        public init(statusText: String,
                    statusColorHex: String,
                    human: Int,
                    terrain: Int,
                    aerial: Int,
                    distanceKm: Double?,
                    updatedAt: Double) {
            self.statusText = statusText
            self.statusColorHex = statusColorHex
            self.human = human
            self.terrain = terrain
            self.aerial = aerial
            self.distanceKm = distanceKm
            self.updatedAt = updatedAt
        }
    }

    public var fireId: String
    public var location: String
    public var isFire: Bool

    public init(fireId: String, location: String, isFire: Bool) {
        self.fireId = fireId
        self.location = location
        self.isFire = isFire
    }
}
#endif
