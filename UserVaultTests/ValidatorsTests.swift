//
//  ValidatorsTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class ValidatorsTests: XCTestCase {

    func testValidEmailReturnsTrue() {
        XCTAssertTrue(Validators.isValidEmail("user@example.com"))
        XCTAssertTrue(Validators.isValidEmail("test.name+tag@domain.co"))
    }

    func testInvalidEmailReturnsFalse() {
        XCTAssertFalse(Validators.isValidEmail(""))
        XCTAssertFalse(Validators.isValidEmail("not-an-email"))
        XCTAssertFalse(Validators.isValidEmail("@domain.com"))
        XCTAssertFalse(Validators.isValidEmail("user@"))
        XCTAssertFalse(Validators.isValidEmail("user @domain.com"))
    }

    func testEmailWithWhitespaceIsTrimmed() {
        XCTAssertTrue(Validators.isValidEmail("  user@example.com  "))
    }

    func testIsNotEmptyWithTextReturnsTrue() {
        XCTAssertTrue(Validators.isNotEmpty("Hello"))
        XCTAssertTrue(Validators.isNotEmpty("  text  "))
    }

    func testIsNotEmptyWithBlankReturnsFalse() {
        XCTAssertFalse(Validators.isNotEmpty(""))
        XCTAssertFalse(Validators.isNotEmpty("   "))
        XCTAssertFalse(Validators.isNotEmpty("\n\t"))
    }
}
