//
//  UserListViewModelTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

@MainActor
final class UserListViewModelTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var mockCoordinator: MockListCoordinator!
    private var sut: UserListViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        mockCoordinator = MockListCoordinator()
        sut = UserListViewModel(
            getUsersUseCase: GetUsersUseCase(repository: mockRepository),
            deleteUserUseCase: DeleteUserUseCase(repository: mockRepository),
            coordinator: mockCoordinator
        )
    }

    override func tearDown() {
        sut = nil
        mockCoordinator = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchUsersSuccess() async {
        mockRepository.users = UserFactory.makeUsers(count: 3)

        await sut.fetchUsers()

        XCTAssertEqual(sut.users.count, 3)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
    }

    func testFetchUsersEmpty() async {
        await sut.fetchUsers()

        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func testFetchUsersError() async {
        mockRepository.shouldThrowError = true

        await sut.fetchUsers()

        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertTrue(sut.showError)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func testDeleteUserRemovesFromList() async {
        mockRepository.users = UserFactory.makeUsers(count: 3)
        await sut.fetchUsers()

        sut.deleteUser(at: IndexSet(integer: 0))

        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(sut.users.count, 2)
    }

    func testNavigateToDetailCallsCoordinator() {
        let user = UserFactory.makeUser()

        sut.navigateToDetail(user: user)

        XCTAssertTrue(mockCoordinator.navigateToDetailCalled)
        XCTAssertEqual(mockCoordinator.lastDetailUser?.id, user.id)
    }

    func testNavigateToCreateCallsCoordinator() {
        sut.navigateToCreate()

        XCTAssertTrue(mockCoordinator.navigateToCreateCalled)
    }
}
