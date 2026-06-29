//
//  CreateUserUseCaseTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class CreateUserUseCaseTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var sut: CreateUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = CreateUserUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecuteCallsRepository() async throws {
        let user = UserFactory.makeUser()

        try await sut.execute(user: user)

        XCTAssertEqual(mockRepository.createCallCount, 1)
        XCTAssertEqual(mockRepository.lastCreatedUser?.name, user.name)
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
