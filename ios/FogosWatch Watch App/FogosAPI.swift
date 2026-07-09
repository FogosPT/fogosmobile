import Foundation

enum FogosAPIError: Error {
    case invalidURL
    case invalidResponse
    case decoding(Error)
}

nonisolated struct FiresEnvelope: Decodable, Sendable {
    let success: Bool?
    let data: [Fire]
}

nonisolated struct NowStatsEnvelope: Decodable, Sendable {
    let success: Bool?
    let data: NowStats
}

nonisolated struct WarningsEnvelope: Decodable, Sendable {
    let success: Bool?
    let data: [WarningItem]
}

actor FogosAPI {
    static let shared = FogosAPI()

    private let base = URL(string: "https://source.fogos.pt")!
    private let session: URLSession

    init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 8
        cfg.timeoutIntervalForResource = 15
        cfg.requestCachePolicy = .reloadRevalidatingCacheData
        cfg.urlCache = URLCache(memoryCapacity: 2_000_000, diskCapacity: 10_000_000)
        session = URLSession(configuration: cfg)
    }

    func fetchFires() async throws -> [Fire] {
        let env: FiresEnvelope = try await get("new/fires")
        return env.data
    }

    func fetchNowStats() async throws -> NowStats {
        let env: NowStatsEnvelope = try await get("v1/now")
        return env.data
    }

    func fetchWarnings() async throws -> [WarningItem] {
        let env: WarningsEnvelope = try await get("v1/warnings")
        return env.data
    }

    private func get<T: Decodable>(_ path: String) async throws -> T {
        let url = base.appendingPathComponent(path)
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw FogosAPIError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw FogosAPIError.decoding(error)
        }
    }
}
