import Foundation
// MARK: - Company
public struct Company: Codable, Equatable {
    let name, catchPhrase, bs: String
}

public extension Company {

    static func fixture(
        name: String = "",
        catchPhrase: String = "",
        bs: String = ""
    ) -> Self {
        .init(
            name: name,
            catchPhrase: catchPhrase,
            bs: bs
        )
    }
}
