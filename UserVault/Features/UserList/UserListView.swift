//
//  UserListView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("loading".localized)
            } else if viewModel.users.isEmpty {
                emptyStateView
            } else {
                userListContent
            }
        }
        .navigationTitle("user_list_title".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.navigateToCreate()
                } label: {
                    Image(systemName: UserListViewConstants.Images.addButton)
                }
                .accessibilityLabel("add_user".localized)
            }
        }
        .alert(
            "error_title".localized,
            isPresented: $viewModel.showError,
            actions: {
                Button("ok".localized, role: .cancel) {}
            },
            message: {
                Text(viewModel.errorMessage ?? "")
            }
        )
        .task {
            await viewModel.fetchUsers()
        }
        .onChange(of: coordinator.shouldRefreshList) { shouldRefresh in
            if shouldRefresh {
                coordinator.shouldRefreshList = false
                Task { await viewModel.fetchUsers() }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: Spacing.medium) {
            Image(systemName: UserListViewConstants.Images.emptyState)
                .font(.system(size: UserListViewConstants.Dimensions.emptyIconSize))
                .foregroundColor(AppColors.secondaryLabel)
            Text("no_users".localized)
                .font(Typography.headline)
                .foregroundColor(AppColors.secondaryLabel)
        }
    }

    private var userListContent: some View {
        List {
            ForEach(viewModel.users) { user in
                UserRowView(user: user)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.navigateToDetail(user: user)
                    }
            }
            .onDelete { offsets in
                viewModel.deleteUser(at: offsets)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchUsers()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = PreviewUserRepository()
        let coordinator = PreviewCoordinator()
        NavigationView {
            UserListView(
                viewModel: UserListViewModel(
                    getUsersUseCase: GetUsersUseCase(repository: repository),
                    deleteUserUseCase: DeleteUserUseCase(repository: repository),
                    coordinator: coordinator
                )
            )
        }
    }
}
