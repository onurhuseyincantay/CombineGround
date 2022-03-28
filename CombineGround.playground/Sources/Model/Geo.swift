import Foundation

// MARK: - Geo
public struct Geo: Codable, Equatable {
    let lat, lng: String
}

public extension Geo {

    static func fixture(
        lat: String = "",
        lng: String = ""
    ) -> Self {
        .init(
            lat: lat,
            lng: lng
        )
    }
}
