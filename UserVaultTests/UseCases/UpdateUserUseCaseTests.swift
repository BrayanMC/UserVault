//
//  UpdateUserUseCaseTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class UpdateUserUseCaseTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var sut: UpdateUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UpdateUserUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecuteCallsRepository() async throws {
        var user = UserFactory.makeUser()
        user.name = "Updated Name"

        try await sut.execute(user: user)

        XCTAssertEqual(mockRepository.updateCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdatedUser?.name, "Updated Name")
    }

    func testExecuteThrowsOnError() async {
        mockRepository.shouldThrowError = true

        do {
            try await sut.execute(user: UserFactory.makeUser())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is UserVaultError)
        }
    }
}
