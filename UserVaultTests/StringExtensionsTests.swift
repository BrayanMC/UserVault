//
//  StringExtensionsTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class StringExtensionsTests: XCTestCase {

    func testTrimmedRemovesWhitespace() {
        XCTAssertEqual("  hello  ".trimmed, "hello")
        XCTAssertEqual("\n\ttext\n".trimmed, "text")
        XCTAssertEqual("clean".trimmed, "clean")
    }

    func testIsBlankWithEmptyString() {
        XCTAssertTrue("".isBlank)
        XCTAssertTrue("   ".isBlank)
        XCTAssertTrue("\n\t".isBlank)
    }

    func testIsBlankWithContent() {
        XCTAssertFalse("hello".isBlank)
        XCTAssertFalse("  a  ".isBlank)
    }
}
