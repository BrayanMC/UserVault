//
//  DeleteUserUseCase.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class DeleteUserUseCase {
    private let repository: UserDeleteRepository

    init(repository: UserDeleteRepository) {
        self.repository = repository
    }

    func execute(userId: Int) async throws {
        try await repository.deleteUser(withId: userId)
    }
}
