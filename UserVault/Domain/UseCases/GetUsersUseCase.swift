//
//  GetUsersUseCase.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class GetUsersUseCase {
    private let repository: UserFetchRepository

    init(repository: UserFetchRepository) {
        self.repository = repository
    }

    func execute() async throws -> [User] {
        try await repository.fetchUsers()
    }
}
