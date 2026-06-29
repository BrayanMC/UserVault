//
//  RealmUserObjectTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class RealmUserObjectTests: XCTestCase {

    func testFromDomainMapsAllFields() {
        let user = UserFactory.makeUser()

        let object = RealmUserObject.fromDomain(user)

        XCTAssertEqual(object.id, user.id)
        XCTAssertEqual(object.name, user.name)
        XCTAssertEqual(object.username, user.username)
        XCTAssertEqual(object.email, user.email)
        XCTAssertEqual(object.phone, user.phone)
        XCTAssertEqual(object.city, user.city)
        XCTAssertEqual(object.street, user.street)
        XCTAssertEqual(object.suite, user.suite)
        XCTAssertEqual(object.zipcode, user.zipcode)
        XCTAssertEqual(object.latitude, user.latitude)
        XCTAssertEqual(object.longitude, user.longitude)
        XCTAssertEqual(object.companyName, user.companyName)
        XCTAssertEqual(object.website, user.website)
        XCTAssertEqual(object.isLocal, user.isLocal)
        XCTAssertFalse(object.isDeleted)
    }

    func testToDomainMapsAllFields() {
        let object = RealmUserObject.fromDomain(UserFactory.makeUser())

        let user = object.toDomain()

        XCTAssertEqual(user.id, object.id)
        XCTAssertEqual(user.name, object.name)
        XCTAssertEqual(user.username, object.username)
        XCTAssertEqual(user.email, object.email)
        XCTAssertEqual(user.phone, object.phone)
        XCTAssertEqual(user.city, object.city)
        XCTAssertEqual(user.street, object.street)
        XCTAssertEqual(user.suite, object.suite)
        XCTAssertEqual(user.zipcode, object.zipcode)
        XCTAssertEqual(user.latitude, object.latitude)
        XCTAssertEqual(user.longitude, object.longitude)
        XCTAssertEqual(user.companyName, object.companyName)
        XCTAssertEqual(user.website, object.website)
        XCTAssertEqual(user.isLocal, object.isLocal)
    }

    func testRoundTripPreservesData() {
        let original = UserFactory.makeUser(id: 42, name: "Round Trip", email: "rt@test.com")

        let restored = RealmUserObject.fromDomain(original).toDomain()

        XCTAssertEqual(original, restored)
    }
}
