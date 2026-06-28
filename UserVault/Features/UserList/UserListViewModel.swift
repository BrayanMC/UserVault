//
//  UserListViewModel.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let getUsersUseCase: GetUsersUseCase
    private let deleteUserUseCase: DeleteUserUseCase
    private weak var coordinator: UserListCoordinatorProtocol?

    init(
        getUsersUseCase: GetUsersUseCase,
        deleteUserUseCase: DeleteUserUseCase,
        coordinator: UserListCoordinatorProtocol
    ) {
        self.getUsersUseCase = getUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.coordinator = coordinator
    }

    func fetchUsers() async {
        isLoading = true
        do {
            users = try await getUsersUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }

    func deleteUser(at offsets: IndexSet) {
        for index in offsets {
            let user = users[index]
            Task {
                do {
                    try await deleteUserUseCase.execute(userId: user.id)
                    users.remove(at: index)
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    func navigateToDetail(user: User) {
        coordinator?.navigateToDetail(user: user)
    }

    func navigateToCreate() {
        coordinator?.navigateToCreate()
    }
}
