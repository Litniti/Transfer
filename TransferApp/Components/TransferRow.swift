//
//  TransferRow.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferRow: View {
    let transfer: Transfer
    var showsChevron: Bool = false

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: transfer.isInstant ? "bolt.fill" : "arrow.up.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColors.primaryBlue)
            }

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                HStack {
                    Text(transfer.beneficiary)
                        .font(AppFonts.headline)
                        .lineLimit(1)
                    Spacer()
                    Text(TransferFormatting.amount(transfer.amount, currency: transfer.currency))
                        .font(AppFonts.callout.weight(.semibold))
                }

                HStack {
                    Text(TransferFormatting.dateTime(transfer.createdAt))
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.secondaryText)
                    Spacer()
                    TransferStatusBadge(status: transfer.status)
                }
            }

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(transfer.beneficiary), \(TransferFormatting.amount(transfer.amount, currency: transfer.currency)), \(transfer.status.displayName)"
        )
    }
}

struct TransferStatusBadge: View {
    let status: TransferStatus

    var body: some View {
        Text(status.displayName)
            .font(AppFonts.caption.weight(.semibold))
            .padding(.horizontal, AppSpacing.xs)
            .padding(.vertical, AppSpacing.xxs)
            .background(backgroundColor.opacity(0.15))
            .foregroundStyle(backgroundColor)
            .clipShape(Capsule())
            .accessibilityLabel("Status: \(status.displayName)")
    }

    private var backgroundColor: Color {
        switch status {
        case .completed: return AppColors.successGreen
        case .pending: return AppColors.warningOrange
        case .failed: return AppColors.errorRed
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(AppFonts.callout)
                .foregroundStyle(AppColors.secondaryText)
            Spacer()
            Text(value)
                .font(AppFonts.callout)
                .multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct FormErrorMessage: View {
    let message: String

    var body: some View {
        Text(message)
            .font(AppFonts.caption)
            .foregroundStyle(AppColors.errorRed)
            .accessibilityLabel("Error: \(message)")
    }
}
