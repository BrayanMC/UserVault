//
//  UserRepositoryImpl.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class UserRepositoryImpl: UserRepositoryProtocol {

    private let remoteDataSource: UserRemoteDataSource
    private let localDataSource: UserLocalDataSource

    init(
        remoteDataSource: UserRemoteDataSource,
        localDataSource: UserLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchUsers() async throws -> [User] {
        let hasRemote = try localDataSource.hasRemoteUsers()
        if !hasRemote {
            let dtos = try await remoteDataSource.fetchUsers()
            let users = dtos.map { $0.toDomain() }
            try localDataSource.saveUsers(users)
        }
        return try localDataSource.fetchActiveUsers()
    }

    func createUser(_ user: User) async throws {
        var newUser = user
        newUser = User(
            id: try localDataSource.nextId(),
            name: user.name,
            username: user.username,
            email: user.email,
            phone: user.phone,
            city: user.city,
            street: user.street,
            suite: user.suite,
            zipcode: user.zipcode,
            latitude: user.latitude,
            longitude: user.longitude,
            companyName: user.companyName,
            website: user.website,
            isLocal: true
        )
        try localDataSource.saveUser(newUser)
    }

    func updateUser(_ user: User) async throws {
        try localDataSource.updateUser(user)
    }

    func deleteUser(withId id: Int) async throws {
        try localDataSource.deleteUser(withId: id)
    }
}
