import Foundation

// MARK: - Address
public struct Address: Codable, Equatable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

public extension Address {

    static func fixture(
        street: String = "",
        suite: String = "",
        city: String = "",
        zipcode: String = "",
        geo: Geo = .fixture()
    ) -> Self {
        .init(
            street: street,
            suite: suite,
            city: city,
            zipcode: zipcode,
            geo: geo
        )
    }
}
