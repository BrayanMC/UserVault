//
//  UserCreateView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct UserCreateView: View {
    @StateObject var viewModel: UserCreateViewModel

    var body: some View {
        Form {
            Section(header: Text("personal_info_section".localized)) {
                TextField("name_placeholder".localized, text: $viewModel.name)
                    .textInputAutocapitalization(.words)

                TextField("email_placeholder".localized, text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                TextField("phone_placeholder".localized, text: $viewModel.phone)
                    .keyboardType(.phonePad)
            }

            Section(header: Text("location_section".localized)) {
                Button {
                    viewModel.requestLocation()
                } label: {
                    HStack {
                        Image(systemName: UserCreateViewConstants.Images.location)
                        Text("get_location".localized)
                    }
                }

                if let latitude = viewModel.locationLatitude,
                   let longitude = viewModel.locationLongitude {
                    HStack {
                        Text("latitude_label".localized)
                            .foregroundColor(AppColors.secondaryLabel)
                        Spacer()
                        Text(latitude)
                    }
                    HStack {
                        Text("longitude_label".localized)
                            .foregroundColor(AppColors.secondaryLabel)
                        Spacer()
                        Text(longitude)
                    }
                }
            }

            Section {
                Button {
                    Task { await viewModel.saveUser() }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("save_user".localized)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
        .navigationTitle("create_user_title".localized)
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
        .alert(
            "location_title".localized,
            isPresented: $viewModel.showLocationAlert,
            actions: {
                Button("ok".localized, role: .cancel) {}
            },
            message: {
                if let lat = viewModel.locationLatitude,
                   let lng = viewModel.locationLongitude {
                    Text(String(
                        localized: "location_result \(lat) \(lng)",
                        comment: "Location result message"
                    ))
                }
            }
        )
        .onReceive(viewModel.locationManager.$location) { coordinate in
            guard let coordinate else { return }
            viewModel.locationLatitude = String(
                format: UserCreateViewConstants.Formatting.coordinateFormat,
                coordinate.latitude
            )
            viewModel.locationLongitude = String(
                format: UserCreateViewConstants.Formatting.coordinateFormat,
                coordinate.longitude
            )
            viewModel.showLocationAlert = true
        }
        .onReceive(viewModel.locationManager.$locationError) { error in
            guard let error else { return }
            viewModel.errorMessage = error.localizedDescription
            viewModel.showError = true
        }
    }
}

struct UserCreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserCreateView(
                viewModel: UserCreateViewModel(
                    createUserUseCase: CreateUserUseCase(repository: PreviewUserRepository()),
                    coordinator: PreviewCoordinator()
                )
            )
        }
    }
}
