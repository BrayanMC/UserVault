//
//  UserRemoteDataSource.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class UserRemoteDataSource {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchUsers() async throws -> [UserDTO] {
        let url = URLBuilder()
            .urlBase()
            .path(.getUsers)
            .build()
        return try await apiClient.fetch(url: url)
    }
}
