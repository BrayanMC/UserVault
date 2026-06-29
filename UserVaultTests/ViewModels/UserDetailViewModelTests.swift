//
//  UserDetailViewModelTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

@MainActor
final class UserDetailViewModelTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var mockCoordinator: MockDetailCoordinator!
    private var sut: UserDetailViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        mockCoordinator = MockDetailCoordinator()
        sut = UserDetailViewModel(
            user: UserFactory.makeUser(),
            updateUserUseCase: UpdateUserUseCase(repository: mockRepository),
            coordinator: mockCoordinator
        )
    }

    override func tearDown() {
        sut = nil
        mockCoordinator = nil
        mockRepository = nil
        super.tearDown()
    }

    func testInitSetsEditedFields() {
        XCTAssertEqual(sut.editedName, "Leanne Graham")
        XCTAssertEqual(sut.editedEmail, "sincere@april.biz")
        XCTAssertFalse(sut.isEditing)
    }

    func testSaveChangesWithEmptyNameShowsError() async {
        sut.editedName = ""

        await sut.saveChanges()

        XCTAssertTrue(sut.showError)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(mockRepository.updateCallCount, 0)
    }

    func testSaveChangesWithEmptyEmailShowsError() async {
        sut.editedEmail = ""

        await sut.saveChanges()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.updateCallCount, 0)
    }

    func testSaveChangesWithInvalidEmailShowsError() async {
        sut.editedEmail = "not-an-email"

        await sut.saveChanges()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.updateCallCount, 0)
    }

    func testSaveChangesSuccessUpdatesUser() async {
        sut.editedName = "New Name"
        sut.editedEmail = "new@email.com"

        await sut.saveChanges()

        XCTAssertEqual(sut.user.name, "New Name")
        XCTAssertEqual(sut.user.email, "new@email.com")
        XCTAssertFalse(sut.isEditing)
        XCTAssertTrue(sut.showSuccess)
        XCTAssertEqual(mockRepository.updateCallCount, 1)
    }

    func testSaveChangesErrorShowsError() async {
        mockRepository.shouldThrowError = true
        sut.editedName = "Valid"
        sut.editedEmail = "valid@email.com"

        await sut.saveChanges()

        XCTAssertTrue(sut.showError)
        XCTAssertFalse(sut.showSuccess)
    }

    func testCancelEditingRestoresValues() {
        sut.editedName = "Changed"
        sut.editedEmail = "changed@email.com"
        sut.isEditing = true

        sut.cancelEditing()

        XCTAssertEqual(sut.editedName, "Leanne Graham")
        XCTAssertEqual(sut.editedEmail, "sincere@april.biz")
        XCTAssertFalse(sut.isEditing)
    }

    func testNavigateBackCallsCoordinator() {
        sut.navigateBack()

        XCTAssertTrue(mockCoordinator.navigateBackCalled)
    }
}
