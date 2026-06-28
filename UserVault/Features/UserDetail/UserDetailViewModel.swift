//
//  UserDetailViewModel.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

@MainActor
final class UserDetailViewModel: ObservableObject {
    @Published var user: User
    @Published var editedName: String
    @Published var editedEmail: String
    @Published var isEditing = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showSuccess = false

    private let updateUserUseCase: UpdateUserUseCase
    private weak var coordinator: UserDetailCoordinatorProtocol?

    init(
        user: User,
        updateUserUseCase: UpdateUserUseCase,
        coordinator: UserDetailCoordinatorProtocol
    ) {
        self.user = user
        self.editedName = user.name
        self.editedEmail = user.email
        self.updateUserUseCase = updateUserUseCase
        self.coordinator = coordinator
    }

    func saveChanges() async {
        guard Validators.isNotEmpty(editedName) else {
            errorMessage = "validation_name_empty".localized
            showError = true
            return
        }

        guard Validators.isNotEmpty(editedEmail) else {
            errorMessage = "validation_email_empty".localized
            showError = true
            return
        }

        guard Validators.isValidEmail(editedEmail) else {
            errorMessage = "validation_email_invalid".localized
            showError = true
            return
        }

        var updatedUser = user
        updatedUser.name = editedName.trimmed
        updatedUser.email = editedEmail.trimmed

        do {
            try await updateUserUseCase.execute(user: updatedUser)
            user = updatedUser
            isEditing = false
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func cancelEditing() {
        editedName = user.name
        editedEmail = user.email
        isEditing = false
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
