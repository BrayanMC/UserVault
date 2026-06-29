//
//  MockUserRepository.swift
//  UserVaultTests
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation
@testable import UserVault

final class MockUserRepository: UserRepositoryProtocol {
    var users: [User] = []
    var shouldThrowError = false
    var fetchCallCount = 0
    var createCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    var lastCreatedUser: User?
    var lastUpdatedUser: User?
    var lastDeletedId: Int?

    func fetchUsers() async throws -> [User] {
        fetchCallCount += 1
        if shouldThrowError {
            throw UserVaultError.network("Mock error")
        }
        return users
    }

    func createUser(_ user: User) async throws {
        createCallCount += 1
        if shouldThrowError {
            throw UserVaultError.persistence("Mock error")
        }
        lastCreatedUser = user
        users.append(user)
    }

    func updateUser(_ user: User) async throws {
        updateCallCount += 1
        if shouldThrowError {
            throw UserVaultError.persistence("Mock error")
        }
        lastUpdatedUser = user
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }

    func deleteUser(withId id: Int) async throws {
        deleteCallCount += 1
        if shouldThrowError {
            throw UserVaultError.persistence("Mock error")
        }
        lastDeletedId = id
        users.removeAll { $0.id == id }
    }
}
