//
//  UserCreateViewModelTests.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import XCTest
@testable import UserVault

@MainActor
final class UserCreateViewModelTests: XCTestCase {
    private var mockRepository: MockUserRepository!
    private var mockCoordinator: MockCreateCoordinator!
    private var sut: UserCreateViewModel!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        mockCoordinator = MockCreateCoordinator()
        sut = UserCreateViewModel(
            createUserUseCase: CreateUserUseCase(repository: mockRepository),
            coordinator: mockCoordinator
        )
    }

    override func tearDown() {
        sut = nil
        mockCoordinator = nil
        mockRepository = nil
        super.tearDown()
    }

    func testSaveUserWithEmptyNameShowsError() async {
        sut.name = ""
        sut.email = "test@email.com"
        sut.phone = "123456"

        await sut.saveUser()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.createCallCount, 0)
    }

    func testSaveUserWithEmptyEmailShowsError() async {
        sut.name = "Test"
        sut.email = ""
        sut.phone = "123456"

        await sut.saveUser()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.createCallCount, 0)
    }

    func testSaveUserWithInvalidEmailShowsError() async {
        sut.name = "Test"
        sut.email = "invalid"
        sut.phone = "123456"

        await sut.saveUser()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.createCallCount, 0)
    }

    func testSaveUserWithEmptyPhoneShowsError() async {
        sut.name = "Test"
        sut.email = "test@email.com"
        sut.phone = ""

        await sut.saveUser()

        XCTAssertTrue(sut.showError)
        XCTAssertEqual(mockRepository.createCallCount, 0)
    }

    func testSaveUserSuccessCallsRepository() async {
        sut.name = "Test User"
        sut.email = "test@email.com"
        sut.phone = "123456"

        await sut.saveUser()

        XCTAssertEqual(mockRepository.createCallCount, 1)
        XCTAssertEqual(mockRepository.lastCreatedUser?.name, "Test User")
        XCTAssertEqual(mockRepository.lastCreatedUser?.email, "test@email.com")
        XCTAssertTrue(mockRepository.lastCreatedUser?.isLocal ?? false)
    }

    func testSaveUserSuccessNavigatesBack() async {
        sut.name = "Test User"
        sut.email = "test@email.com"
        sut.phone = "123456"

        await sut.saveUser()

        XCTAssertTrue(mockCoordinator.navigateBackCalled)
    }

    func testSaveUserUsesDefaultLocationWhenNil() async {
        sut.name = "Test"
        sut.email = "test@email.com"
        sut.phone = "123"

        await sut.saveUser()

        XCTAssertEqual(mockRepository.lastCreatedUser?.latitude, Constants.DefaultLocation.latitude)
        XCTAssertEqual(mockRepository.lastCreatedUser?.longitude, Constants.DefaultLocation.longitude)
    }

    func testSaveUserUsesProvidedLocation() async {
        sut.name = "Test"
        sut.email = "test@email.com"
        sut.phone = "123"
        sut.locationLatitude = "10.0000"
        sut.locationLongitude = "20.0000"

        await sut.saveUser()

        XCTAssertEqual(mockRepository.lastCreatedUser?.latitude, "10.0000")
        XCTAssertEqual(mockRepository.lastCreatedUser?.longitude, "20.0000")
    }

    func testSaveUserGeneratesUsername() async {
        sut.name = "John Doe"
        sut.email = "john@email.com"
        sut.phone = "123"

        await sut.saveUser()

        XCTAssertEqual(mockRepository.lastCreatedUser?.username, "john.doe")
    }

    func testSaveUserErrorShowsError() async {
        mockRepository.shouldThrowError = true
        sut.name = "Test"
        sut.email = "test@email.com"
        sut.phone = "123"

        await sut.saveUser()

        XCTAssertTrue(sut.showError)
        XCTAssertFalse(mockCoordinator.navigateBackCalled)
    }
}
