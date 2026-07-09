import Foundation

nonisolated struct Fire: Identifiable, Decodable, Hashable, Sendable {
    let id: String
    let statusCode: Int
    let statusText: String
    let statusColor: String
    let nature: String
    let natureCode: String
    let aerial: Int
    let terrain: Int
    let human: Int
    let district: String
    let city: String
    let town: String
    let local: String
    let lat: Double
    let lng: Double
    let date: String
    let hour: String
    let dateTimeSec: Int
    let active: Bool
    let important: Bool
    let isFire: Bool

    enum CodingKeys: String, CodingKey {
        case id, statusCode, statusColor
        case statusText = "status"
        case nature = "natureza"
        case natureCode = "naturezaCode"
        case aerial, terrain
        case human = "man"
        case district
        case city = "concelho"
        case town = "freguesia"
        case local = "localidade"
        case lat, lng, date, hour
        case dateTime
        case active, important, isFire
    }

    private struct SecEnvelope: Decodable { let sec: Int }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(String.self, forKey: .id) ?? ""
        statusCode = try c.decodeIfPresent(Int.self, forKey: .statusCode) ?? 0
        statusText = try c.decodeIfPresent(String.self, forKey: .statusText) ?? ""
        statusColor = try c.decodeIfPresent(String.self, forKey: .statusColor) ?? ""
        nature = try c.decodeIfPresent(String.self, forKey: .nature) ?? ""
        natureCode = try c.decodeIfPresent(String.self, forKey: .natureCode) ?? ""
        aerial = try c.decodeIfPresent(Int.self, forKey: .aerial) ?? 0
        terrain = try c.decodeIfPresent(Int.self, forKey: .terrain) ?? 0
        human = try c.decodeIfPresent(Int.self, forKey: .human) ?? 0
        district = try c.decodeIfPresent(String.self, forKey: .district) ?? ""
        city = try c.decodeIfPresent(String.self, forKey: .city) ?? ""
        town = try c.decodeIfPresent(String.self, forKey: .town) ?? ""
        local = try c.decodeIfPresent(String.self, forKey: .local) ?? ""
        lat = try c.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        lng = try c.decodeIfPresent(Double.self, forKey: .lng) ?? 0
        date = try c.decodeIfPresent(String.self, forKey: .date) ?? ""
        hour = try c.decodeIfPresent(String.self, forKey: .hour) ?? ""
        dateTimeSec = (try? c.decode(SecEnvelope.self, forKey: .dateTime))?.sec ?? 0
        active = try c.decodeIfPresent(Bool.self, forKey: .active) ?? false
        important = try c.decodeIfPresent(Bool.self, forKey: .important) ?? false
        // isFire in the backend is sometimes bool, sometimes int, sometimes absent
        if let b = try? c.decode(Bool.self, forKey: .isFire) {
            isFire = b
        } else if let i = try? c.decode(Int.self, forKey: .isFire) {
            isFire = i == 1
        } else {
            isFire = true
        }
    }

    func distanceKm(from lat: Double, _ lng: Double) -> Double {
        let R = 6371.0
        let dLat = (self.lat - lat) * .pi / 180
        let dLng = (self.lng - lng) * .pi / 180
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(lat * .pi / 180) * cos(self.lat * .pi / 180) *
                sin(dLng/2) * sin(dLng/2)
        return R * 2 * atan2(sqrt(a), sqrt(1 - a))
    }
}
