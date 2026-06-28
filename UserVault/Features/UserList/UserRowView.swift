//
//  UserRowView.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(user.username)
                .font(Typography.headline)
                .foregroundColor(AppColors.label)
            Text(user.name)
                .font(Typography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)
            HStack(spacing: Spacing.medium) {
                Label(user.phone, systemImage: UserListViewConstants.Images.phone)
                    .font(Typography.caption)
                    .foregroundColor(AppColors.secondaryLabel)
                    .lineLimit(1)
            }
            HStack(spacing: Spacing.medium) {
                Label(user.email, systemImage: UserListViewConstants.Images.email)
                    .font(Typography.caption)
                    .foregroundColor(AppColors.secondaryLabel)
                    .lineLimit(1)
                Spacer()
                Label(user.city, systemImage: UserListViewConstants.Images.city)
                    .font(Typography.caption)
                    .foregroundColor(AppColors.secondaryLabel)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, Spacing.extraSmall)
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView(user: User.preview)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
