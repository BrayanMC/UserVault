//
//  UserVaultApp.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

@main
struct UserVaultApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            MainView(dependencies: dependencies)
        }
    }
}
