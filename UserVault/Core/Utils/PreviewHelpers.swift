//
//  PreviewHelpers.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class PreviewUserRepository: UserRepositoryProtocol {

    func fetchUsers() async throws -> [User] {
        [User.preview]
    }

    func createUser(_ user: User) async throws {}

    func updateUser(_ user: User) async throws {}

    func deleteUser(withId id: Int) async throws {}
}

@MainActor
final class PreviewCoordinator: UserListCoordinatorProtocol,
                                 UserDetailCoordinatorProtocol,
                                 UserCreateCoordinatorProtocol {

    func navigateToDetail(user: User) {}
    func navigateToCreate() {}
    func navigateBack() {}
}
