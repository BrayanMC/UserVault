//
//  ViewModelFactory.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

@MainActor
final class ViewModelFactory {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func makeUserListViewModel(coordinator: UserListCoordinatorProtocol) -> UserListViewModel {
        UserListViewModel(
            getUsersUseCase: dependencies.getUsersUseCase,
            deleteUserUseCase: dependencies.deleteUserUseCase,
            coordinator: coordinator
        )
    }

    func makeUserDetailViewModel(user: User, coordinator: UserDetailCoordinatorProtocol) -> UserDetailViewModel {
        UserDetailViewModel(
            user: user,
            updateUserUseCase: dependencies.updateUserUseCase,
            coordinator: coordinator
        )
    }

    func makeUserCreateViewModel(coordinator: UserCreateCoordinatorProtocol) -> UserCreateViewModel {
        UserCreateViewModel(
            createUserUseCase: dependencies.createUserUseCase,
            coordinator: coordinator
        )
    }
}
