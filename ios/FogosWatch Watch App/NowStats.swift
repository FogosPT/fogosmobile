import Foundation

/// The `/v1/now` endpoint returns some fields as strings and some as
/// numbers depending on the deployment, so we accept both.
nonisolated struct NowStats: Decodable, Sendable {
    let man: Int
    let aerial: Int
    let cars: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case man, aerial, cars, total
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        man = Self.decodeInt(c, key: .man)
        aerial = Self.decodeInt(c, key: .aerial)
        cars = Self.decodeInt(c, key: .cars)
        total = Self.decodeInt(c, key: .total)
    }

    private static func decodeInt(_ c: KeyedDecodingContainer<CodingKeys>, key: CodingKeys) -> Int {
        if let n = try? c.decode(Int.self, forKey: key) { return n }
        if let s = try? c.decode(String.self, forKey: key), let n = Int(s) { return n }
        return 0
    }
}
