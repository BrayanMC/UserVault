//
//  AppCoordinator.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject,
                             UserListCoordinatorProtocol,
                             UserDetailCoordinatorProtocol,
                             UserCreateCoordinatorProtocol {
    @Published var selectedUser: User?
    @Published var isDetailActive = false
    @Published var isCreateActive = false
    @Published var shouldRefreshList = false

    private let viewModelFactory: ViewModelFactory

    init(dependencies: AppDependencies) {
        self.viewModelFactory = ViewModelFactory(dependencies: dependencies)
    }

    func navigateToDetail(user: User) {
        selectedUser = user
        isDetailActive = true
    }

    func navigateToCreate() {
        isCreateActive = true
    }

    func navigateBack() {
        if isCreateActive {
            isCreateActive = false
            shouldRefreshList = true
        } else if isDetailActive {
            isDetailActive = false
            selectedUser = nil
        }
    }

    func makeUserListViewModel() -> UserListViewModel {
        viewModelFactory.makeUserListViewModel(coordinator: self)
    }

    func makeUserDetailViewModel(user: User) -> UserDetailViewModel {
        viewModelFactory.makeUserDetailViewModel(user: user, coordinator: self)
    }

    func makeUserCreateViewModel() -> UserCreateViewModel {
        viewModelFactory.makeUserCreateViewModel(coordinator: self)
    }
}
