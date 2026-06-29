//
//  UserFactory.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation
@testable import UserVault

enum UserFactory {

    static func makeUser(
        id: Int = 1,
        name: String = "Leanne Graham",
        username: String = "Bret",
        email: String = "sincere@april.biz",
        phone: String = "1-770-736-8031",
        city: String = "Gwenborough",
        isLocal: Bool = false
    ) -> User {
        User(
            id: id,
            name: name,
            username: username,
            email: email,
            phone: phone,
            city: city,
            street: "Kulas Light",
            suite: "Apt. 556",
            zipcode: "92998-3874",
            latitude: "-37.3159",
            longitude: "81.1496",
            companyName: "Romaguera-Crona",
            website: "hildegard.org",
            isLocal: isLocal
        )
    }

    static func makeUsers(count: Int = 3) -> [User] {
        (1...count).map { makeUser(id: $0, name: "User \($0)", username: "user\($0)") }
    }
}
