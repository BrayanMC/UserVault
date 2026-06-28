//
//  UpdateUserUseCase.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class UpdateUserUseCase {
    private let repository: UserUpdateRepository

    init(repository: UserUpdateRepository) {
        self.repository = repository
    }

    func execute(user: User) async throws {
        try await repository.updateUser(user)
    }
}
