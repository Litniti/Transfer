//
//  ProfileView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppDependencyContainer.self) private var dependencies
    @State private var viewModel: ProfileViewModel?

    var body: some View {
        Group {
            if let viewModel {
                List {
                    Section {
                        HStack(spacing: AppSpacing.md) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.primaryBlue.opacity(0.15))
                                    .frame(width: 64, height: 64)
                                Text(viewModel.profile.name.prefix(1).uppercased())
                                    .font(AppFonts.title)
                                    .foregroundStyle(AppColors.primaryBlue)
                            }
                            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                Text(viewModel.profile.name)
                                    .font(AppFonts.headline)
                                Text(viewModel.profile.email)
                                    .font(AppFonts.caption)
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                        .padding(.vertical, AppSpacing.xs)
                        .accessibilityElement(children: .combine)
                    }

                    Section("Settings") {
                        Toggle(isOn: Bindable(viewModel.appearanceStore).isDarkModeEnabled) {
                            Label("Dark Mode", systemImage: "moon.fill")
                        }
                        .accessibilityHint("Toggles dark appearance for the app")

                        HStack {
                            Label("Default Currency", systemImage: "dollarsign.circle")
                            Spacer()
                            Text(viewModel.profile.defaultCurrency.rawValue)
                                .foregroundStyle(AppColors.secondaryText)
                        }
                    }

                    Section("Account") {
                        HStack {
                            Label("Account Balance", systemImage: "banknote")
                            Spacer()
                            Text(TransferFormatting.amount(
                                viewModel.profile.accountBalance,
                                currency: viewModel.profile.defaultCurrency
                            ))
                            .foregroundStyle(AppColors.secondaryText)
                        }
                    }

                    Section {
                        Label("TransferApp v1.0", systemImage: "info.circle")
                            .foregroundStyle(AppColors.secondaryText)
                    }
                }
                .themedListSurface()
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            if viewModel == nil {
                viewModel = dependencies.makeProfileViewModel()
            }
            viewModel?.load()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AppDependencyContainer.preview)
    }
}
