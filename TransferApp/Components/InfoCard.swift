//
//  InfoCard.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct InfoCard: View {
    let title: String
    let value: String
    var icon: String?
    var accentColor: Color = AppColors.primaryBlue

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack(spacing: AppSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundStyle(accentColor)
                }
                Text(title)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }
            Text(value)
                .font(AppFonts.statValue)
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
        .shadow(color: .black.opacity(0.06), radius: AppSpacing.shadowRadius, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}
