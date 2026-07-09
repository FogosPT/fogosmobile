import Foundation

nonisolated struct WarningItem: Decodable, Identifiable, Sendable {
    let id: String
    let timestamp: String
    let title: String
    let text: String

    enum CodingKeys: String, CodingKey {
        case timestamp = "label"
        case title
        case text
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = (try? c.decode(String.self, forKey: .timestamp)) ?? ""
        title = (try? c.decode(String.self, forKey: .title)) ?? ""
        text = (try? c.decode(String.self, forKey: .text)) ?? ""
        id = "\(timestamp)_\(title)"
    }

    /// Rough severity from title keywords.
    var severity: Severity {
        let lower = title.lowercased()
        if lower.contains("verm") { return .red }
        if lower.contains("laran") { return .orange }
        if lower.contains("amare") { return .yellow }
        return .green
    }

    enum Severity {
        case green, yellow, orange, red
    }
}
