//
//  UserListCoordinator.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

@MainActor
protocol UserListCoordinatorProtocol: AnyObject {
    func navigateToDetail(user: User)
    func navigateToCreate()
}
