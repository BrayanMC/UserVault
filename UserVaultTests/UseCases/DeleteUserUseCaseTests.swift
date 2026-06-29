//
//  DeleteUserUseCaseTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

final class DeleteUserUseCaseTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var sut: DeleteUserUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = DeleteUserUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecuteCallsRepositoryWithCorrectId() async throws {
        try await sut.execute(userId: 5)

        XCTAssertEqual(mockRepository.deleteCallCount, 1)
        XCTAssertEqual(mockRepository.lastDeletedId, 5)
    }

    func testExecuteThrowsOnError() async {
        mockRepository.shouldThrowError = true

        do {
            try await sut.execute(userId: 1)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is UserVaultError)
        }
    }
}
