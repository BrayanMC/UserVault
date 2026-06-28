//
//  URLBuilderTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class URLBuilderTests: XCTestCase {

    func testBuildUsersURL() {
        let url = URLBuilder()
            .urlBase()
            .path(.getUsers)
            .build()

        XCTAssertEqual(url, "https://jsonplaceholder.typicode.com/users")
    }

    func testBuildBaseOnlyURL() {
        let url = URLBuilder()
            .urlBase()
            .build()

        XCTAssertEqual(url, "https://jsonplaceholder.typicode.com/")
    }
}
