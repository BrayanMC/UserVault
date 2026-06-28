//
//  UserCreateViewModel.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import Foundation

@MainActor
final class UserCreateViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showLocationAlert = false
    @Published var locationLatitude: String?
    @Published var locationLongitude: String?

    let locationManager = LocationManager()

    private let createUserUseCase: CreateUserUseCase
    private weak var coordinator: UserCreateCoordinatorProtocol?

    init(
        createUserUseCase: CreateUserUseCase,
        coordinator: UserCreateCoordinatorProtocol
    ) {
        self.createUserUseCase = createUserUseCase
        self.coordinator = coordinator
    }

    func saveUser() async {
        guard Validators.isNotEmpty(name) else {
            errorMessage = "validation_name_empty".localized
            showError = true
            return
        }

        guard Validators.isNotEmpty(email) else {
            errorMessage = "validation_email_empty".localized
            showError = true
            return
        }

        guard Validators.isValidEmail(email) else {
            errorMessage = "validation_email_invalid".localized
            showError = true
            return
        }

        guard Validators.isNotEmpty(phone) else {
            errorMessage = "validation_phone_empty".localized
            showError = true
            return
        }

        isLoading = true

        let newUser = User(
            id: 0,
            name: name.trimmed,
            username: name.trimmed.lowercased().replacingOccurrences(of: " ", with: "."),
            email: email.trimmed,
            phone: phone.trimmed,
            city: "",
            street: "",
            suite: "",
            zipcode: "",
            latitude: locationLatitude ?? Constants.DefaultLocation.latitude,
            longitude: locationLongitude ?? Constants.DefaultLocation.longitude,
            companyName: "",
            website: "",
            isLocal: true
        )

        do {
            try await createUserUseCase.execute(user: newUser)
            coordinator?.navigateBack()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isLoading = false
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func navigateBack() {
        coordinator?.navigateBack()
    }
}
