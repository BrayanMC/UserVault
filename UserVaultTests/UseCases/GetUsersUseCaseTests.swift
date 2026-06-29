//
//  GetUsersUseCaseTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class GetUsersUseCaseTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var sut: GetUsersUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = GetUsersUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecuteReturnsUsers() async throws {
        mockRepository.users = UserFactory.makeUsers(count: 3)

        let result = try await sut.execute()

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(mockRepository.fetchCallCount, 1)
    }

    func testExecuteReturnsEmptyWhenNoUsers() async throws {
        let result = try await sut.execute()

        XCTAssertTrue(result.isEmpty)
    }

    func testExecuteThrowsOnError() async {
        mockRepository.shouldThrowError = true

        do {
            _ = try await sut.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is UserVaultError)
        }
    }
}
