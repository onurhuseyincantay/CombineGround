import Foundation

public typealias UserList = [User]
// MARK: - UserElement
public struct User: Codable, Identifiable, Equatable {
    public let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

public extension User {

    static func fixture(
        id: Int = 0,
        name: String = "",
        username: String = "",
        email: String = "",
        address: Address = .fixture(),
        phone: String = "",
        website: String = "",
        company: Company = .fixture()
    ) -> Self {
        .init(
            id: id,
            name: name,
            username: username,
            email: email,
            address: address,
            phone: phone,
            website: website,
            company: company
        )
    }
}
