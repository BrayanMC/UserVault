//
//  UserRepositoryProtocol.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

/// Defines the contract for fetching users.
protocol UserFetchRepository {
    /// Fetches all active users, using cache when available.
    func fetchUsers() async throws -> [User]
}

/// Defines the contract for creating users.
protocol UserCreateRepository {
    /// Creates a new local user with the given data.
    func createUser(_ user: User) async throws
}

/// Defines the contract for updating users.
protocol UserUpdateRepository {
    /// Updates the name and email of an existing user.
    func updateUser(_ user: User) async throws
}

/// Defines the contract for deleting users.
protocol UserDeleteRepository {
    /// Performs a logical deletion of the user with the given identifier.
    func deleteUser(withId id: Int) async throws
}

/// Aggregated protocol for full user data operations.
protocol UserRepositoryProtocol: UserFetchRepository, UserCreateRepository, UserUpdateRepository, UserDeleteRepository {}
