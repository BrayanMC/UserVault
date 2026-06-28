//
//  CreateUserUseCase.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class CreateUserUseCase {
    private let repository: UserCreateRepository

    init(repository: UserCreateRepository) {
        self.repository = repository
    }

    func execute(user: User) async throws {
        try await repository.createUser(user)
    }
}
