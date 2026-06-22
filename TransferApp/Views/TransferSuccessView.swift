//
//  TransferSuccessView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferSuccessView: View {
    let transfer: Transfer
    @Binding var selectedTab: AppTab
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.successGreen.opacity(0.15))
                    .frame(width: 100, height: 100)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(AppColors.successGreen)
            }
            .accessibilityHidden(true)

            VStack(spacing: AppSpacing.xs) {
                Text("Transfer Successful")
                    .font(AppFonts.title)
                Text("Your transfer has been submitted and saved.")
                    .font(AppFonts.callout)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: AppSpacing.sm) {
                DetailRow(
                    title: "Amount",
                    value: TransferFormatting.amount(transfer.amount, currency: transfer.currency)
                )
                DetailRow(title: "Beneficiary", value: transfer.beneficiary)
                DetailRow(title: "Status", value: transfer.status.displayName)
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
            .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
            .padding(.horizontal, AppSpacing.md)

            Spacer()

            VStack(spacing: AppSpacing.sm) {
                PrimaryButton(title: "View History") {
                    onDone()
                    selectedTab = .history
                }
                Button("Create Another Transfer") {
                    onDone()
                    selectedTab = .transfer
                }
                .font(AppFonts.callout)
                .foregroundStyle(AppColors.primaryBlue)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .themedBackground()
        .navigationBarBackButtonHidden(true)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    @Previewable @State var tab = AppTab.transfer
    NavigationStack {
        TransferSuccessView(
            transfer: Transfer(
                beneficiary: "John Doe",
                iban: "MA6400112345678901234567890",
                amount: 2500,
                currency: .MAD,
                reason: "Rent",
                status: .completed,
                executionDate: Date(),
                isInstant: false
            ),
            selectedTab: $tab,
            onDone: {}
        )
    }
}
