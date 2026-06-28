//
//  UserDTOTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class UserDTOTests: XCTestCase {

    func testToDomainMapsAllFields() {
        let dto = UserDTO(
            id: 1,
            name: "Leanne Graham",
            username: "Bret",
            email: "Sincere@april.biz",
            phone: "1-770-736-8031",
            website: "hildegard.org",
            address: UserDTO.AddressDTO(
                street: "Kulas Light",
                suite: "Apt. 556",
                city: "Gwenborough",
                zipcode: "92998-3874",
                geo: UserDTO.AddressDTO.GeoDTO(lat: "-37.3159", lng: "81.1496")
            ),
            company: UserDTO.CompanyDTO(
                name: "Romaguera-Crona",
                catchPhrase: "Multi-layered",
                bs: "harness"
            )
        )

        let user = dto.toDomain()

        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Leanne Graham")
        XCTAssertEqual(user.username, "Bret")
        XCTAssertEqual(user.email, "Sincere@april.biz")
        XCTAssertEqual(user.phone, "1-770-736-8031")
        XCTAssertEqual(user.city, "Gwenborough")
        XCTAssertEqual(user.street, "Kulas Light")
        XCTAssertEqual(user.suite, "Apt. 556")
        XCTAssertEqual(user.zipcode, "92998-3874")
        XCTAssertEqual(user.latitude, "-37.3159")
        XCTAssertEqual(user.longitude, "81.1496")
        XCTAssertEqual(user.companyName, "Romaguera-Crona")
        XCTAssertEqual(user.website, "hildegard.org")
        XCTAssertFalse(user.isLocal)
    }

    func testDTODecodesFromJSON() throws {
        let json = """
        {
            "id": 2,
            "name": "Ervin Howell",
            "username": "Antonette",
            "email": "Shanna@melissa.tv",
            "phone": "010-692-6593",
            "website": "anastasia.net",
            "address": {
                "street": "Victor Plains",
                "suite": "Suite 879",
                "city": "Wisokyburgh",
                "zipcode": "90566-7771",
                "geo": { "lat": "-43.9509", "lng": "-34.4618" }
            },
            "company": {
                "name": "Deckow-Crist",
                "catchPhrase": "Proactive didactic",
                "bs": "synergize scalable"
            }
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(UserDTO.self, from: json)

        XCTAssertEqual(dto.id, 2)
        XCTAssertEqual(dto.username, "Antonette")
        XCTAssertEqual(dto.address.city, "Wisokyburgh")
        XCTAssertEqual(dto.address.geo.lat, "-43.9509")
        XCTAssertEqual(dto.company.name, "Deckow-Crist")
    }
}
