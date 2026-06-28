//
//  UserDetailView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                profileHeader
                userInfoSection
            }
            .padding(Spacing.medium)
        }
        .navigationTitle(viewModel.user.username)
        .navigationBarItems(
            trailing: Button("edit".localized) {
                viewModel.isEditing = true
            }
        )
        .sheet(isPresented: $viewModel.isEditing) {
            UserEditView(viewModel: viewModel)
        }
        .alert(isPresented: $viewModel.showSuccess) {
            Alert(
                title: Text("success_title".localized),
                message: Text("user_updated".localized),
                dismissButton: .cancel(Text("ok".localized))
            )
        }
    }

    private var profileHeader: some View {
        VStack(spacing: Spacing.small) {
            Image(systemName: UserDetailViewConstants.Images.profile)
                .resizable()
                .scaledToFit()
                .frame(
                    width: UserDetailViewConstants.Dimensions.profileImageSize,
                    height: UserDetailViewConstants.Dimensions.profileImageSize
                )
                .foregroundColor(AppColors.accent)
            Text(viewModel.user.name)
                .font(Typography.title2)
                .fontWeight(.bold)
            Text("@\(viewModel.user.username)")
                .font(Typography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)
        }
    }

    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            DetailRow(
                icon: UserDetailViewConstants.Images.email,
                title: "email_label".localized,
                value: viewModel.user.email
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.phone,
                title: "phone_label".localized,
                value: viewModel.user.phone
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.city,
                title: "city_label".localized,
                value: viewModel.user.city
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.street,
                title: "street_label".localized,
                value: "\(viewModel.user.street), \(viewModel.user.suite)"
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.zipcode,
                title: "zipcode_label".localized,
                value: viewModel.user.zipcode
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.coordinates,
                title: "coordinates_label".localized,
                value: "\(viewModel.user.latitude), \(viewModel.user.longitude)"
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.company,
                title: "company_label".localized,
                value: viewModel.user.companyName
            )
            DetailRow(
                icon: UserDetailViewConstants.Images.website,
                title: "website_label".localized,
                value: viewModel.user.website
            )
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .cornerRadius(UserDetailViewConstants.Dimensions.cornerRadius)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailView(
                viewModel: UserDetailViewModel(
                    user: User.preview,
                    updateUserUseCase: UpdateUserUseCase(repository: PreviewUserRepository()),
                    coordinator: PreviewCoordinator()
                )
            )
        }
    }
}
