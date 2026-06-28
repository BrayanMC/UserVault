//
//  User+Extensions.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

extension User: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User {
    static let preview = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "sincere@april.biz",
        phone: "1-770-736-8031",
        city: "Gwenborough",
        street: "Kulas Light",
        suite: "Apt. 556",
        zipcode: "92998-3874",
        latitude: "-37.3159",
        longitude: "81.1496",
        companyName: "Romaguera-Crona",
        website: "hildegard.org",
        isLocal: false
    )
}
