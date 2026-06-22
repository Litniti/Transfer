//
//  PrimaryButton.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(AppFonts.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
        }
        .background(isEnabled ? AppColors.primaryBlue : AppColors.primaryBlue.opacity(0.4))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.buttonRadius))
        .disabled(isLoading || isEnabled == false)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isLoading ? [.updatesFrequently] : [])
    }
}

struct PrimaryBottomButton: View {
    let title: String
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        VStack {
            PrimaryButton(
                title: title,
                isLoading: isLoading,
                isEnabled: isEnabled,
                action: action
            )
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
        }
        .background(.bar)
    }
}
