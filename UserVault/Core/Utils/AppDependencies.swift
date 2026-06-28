//
//  AppDependencies.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

final class AppDependencies {
    let userRepository: UserRepositoryProtocol
    let getUsersUseCase: GetUsersUseCase
    let createUserUseCase: CreateUserUseCase
    let updateUserUseCase: UpdateUserUseCase
    let deleteUserUseCase: DeleteUserUseCase

    init() {
        let apiClient = APIClient()
        let remoteDataSource = UserRemoteDataSource(apiClient: apiClient)
        let localDataSource = UserLocalDataSource()
        userRepository = UserRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )

        getUsersUseCase = GetUsersUseCase(repository: userRepository)
        createUserUseCase = CreateUserUseCase(repository: userRepository)
        updateUserUseCase = UpdateUserUseCase(repository: userRepository)
        deleteUserUseCase = DeleteUserUseCase(repository: userRepository)
    }
}
