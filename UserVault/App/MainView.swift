//
//  MainView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct MainView: View {
    @StateObject private var coordinator: AppCoordinator

    init(dependencies: AppDependencies) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(dependencies: dependencies))
    }

    var body: some View {
        NavigationView {
            UserListView(viewModel: coordinator.makeUserListViewModel())
                .background(
                    NavigationLink(
                        isActive: $coordinator.isDetailActive
                    ) {
                        if let user = coordinator.selectedUser {
                            UserDetailView(
                                viewModel: coordinator.makeUserDetailViewModel(user: user)
                            )
                        }
                    } label: {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(
                        isActive: $coordinator.isCreateActive
                    ) {
                        UserCreateView(
                            viewModel: coordinator.makeUserCreateViewModel()
                        )
                    } label: {
                        EmptyView()
                    }
                )
        }
        .navigationViewStyle(.stack)
        .environmentObject(coordinator)
    }
}
