//
//  MockCoordinator.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation
@testable import UserVault

@MainActor
final class MockListCoordinator: UserListCoordinatorProtocol {
    var navigateToDetailCalled = false
    var navigateToCreateCalled = false
    var lastDetailUser: User?

    func navigateToDetail(user: User) {
        navigateToDetailCalled = true
        lastDetailUser = user
    }

    func navigateToCreate() {
        navigateToCreateCalled = true
    }
}

@MainActor
final class MockDetailCoordinator: UserDetailCoordinatorProtocol {
    var navigateBackCalled = false

    func navigateBack() {
        navigateBackCalled = true
    }
}

@MainActor
final class MockCreateCoordinator: UserCreateCoordinatorProtocol {
    var navigateBackCalled = false

    func navigateBack() {
        navigateBackCalled = true
    }
}
