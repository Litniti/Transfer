//
//  BalanceCard.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct BalanceCard: View {
    let balance: Double
    let currency: Currency
    var userName: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Welcome back")
                        .font(AppFonts.caption)
                        .foregroundStyle(.white.opacity(0.85))
                    Text(userName)
                        .font(AppFonts.headline)
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "wallet.pass.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text("Current Balance")
                    .font(AppFonts.caption)
                    .foregroundStyle(.white.opacity(0.85))
                Text(TransferFormatting.amount(balance, currency: currency))
                    .font(AppFonts.balance)
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
        .shadow(color: AppColors.primaryBlue.opacity(0.35), radius: AppSpacing.shadowRadius, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current balance \(TransferFormatting.amount(balance, currency: currency))")
    }
}
