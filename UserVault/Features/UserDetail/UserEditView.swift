//
//  UserEditView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct UserEditView: View {
    @ObservedObject var viewModel: UserDetailViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("edit_info_title".localized)) {
                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text("name_label".localized)
                            .font(Typography.caption)
                            .foregroundColor(AppColors.secondaryLabel)
                        TextField("name_placeholder".localized, text: $viewModel.editedName)
                    }

                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text("email_label".localized)
                            .font(Typography.caption)
                            .foregroundColor(AppColors.secondaryLabel)
                        TextField("email_placeholder".localized, text: $viewModel.editedEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle("edit".localized)
            .navigationBarItems(
                leading: Button("cancel".localized) {
                    viewModel.cancelEditing()
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("save".localized) {
                    Task {
                        await viewModel.saveChanges()
                        if viewModel.showSuccess {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            )
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("error_title".localized),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .cancel(Text("ok".localized))
                )
            }
        }
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditView(
            viewModel: UserDetailViewModel(
                user: User.preview,
                updateUserUseCase: UpdateUserUseCase(repository: PreviewUserRepository()),
                coordinator: PreviewCoordinator()
            )
        )
    }
}
