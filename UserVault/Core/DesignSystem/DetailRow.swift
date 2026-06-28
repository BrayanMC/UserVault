//
//  DetailRow.swift
//  UserVault
//
//  Created by Brayan Munoz Campos on 28/06/2026.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.small) {
            Image(systemName: icon)
                .foregroundColor(AppColors.accent)
                .frame(width: DetailRowConstants.Dimensions.iconWidth)
            VStack(alignment: .leading, spacing: DetailRowConstants.Dimensions.textSpacing) {
                Text(title)
                    .font(Typography.caption)
                    .foregroundColor(AppColors.secondaryLabel)
                Text(value)
                    .font(Typography.body)
            }
        }
        .padding(.vertical, Spacing.extraSmall)
    }
}

struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailRow(icon: "envelope.fill", title: "Email", value: "test@example.com")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
