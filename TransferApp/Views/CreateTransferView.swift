//
//  CreateTransferView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct CreateTransferView: View {
    @Binding var selectedTab: AppTab
    @State private var viewModel = CreateTransferViewModel()
    @State private var draftForRecap: TransferDraft?

    var body: some View {
        Form {
            Section("Beneficiary") {
                TextField("Beneficiary name", text: $viewModel.beneficiary)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Beneficiary name")
                    .onChange(of: viewModel.beneficiary) {
                        viewModel.clearError(for: .beneficiary)
                    }

                if let error = viewModel.errorMessage(for: .beneficiary) {
                    FormErrorMessage(message: error)
                }
            }

            Section("Account") {
                TextField("IBAN", text: $viewModel.iban)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .accessibilityLabel("IBAN")
                    .onChange(of: viewModel.iban) {
                        viewModel.clearError(for: .iban)
                    }

                if let error = viewModel.errorMessage(for: .iban) {
                    FormErrorMessage(message: error)
                }
            }

            Section("Amount") {
                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .accessibilityLabel("Transfer amount")
                    .onChange(of: viewModel.amount) {
                        viewModel.clearError(for: .amount)
                    }

                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue).tag(currency)
                    }
                }
                .accessibilityLabel("Currency")

                if let error = viewModel.errorMessage(for: .amount) {
                    FormErrorMessage(message: error)
                }
            }

            Section("Details") {
                TextField("Transfer reason", text: $viewModel.reason)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Transfer reason")
                    .onChange(of: viewModel.reason) {
                        viewModel.clearError(for: .reason)
                    }

                if let error = viewModel.errorMessage(for: .reason) {
                    FormErrorMessage(message: error)
                }

                if viewModel.isInstant {
                    Text("Instant transfers are executed immediately.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    executionDatePicker
                        .onChange(of: viewModel.executionDate) {
                            viewModel.clearError(for: .executionDate)
                        }

                    if let error = viewModel.errorMessage(for: .executionDate) {
                        FormErrorMessage(message: error)
                    }
                }

                Toggle("Instant transfer", isOn: $viewModel.isInstant)
                    .accessibilityHint("When enabled, the transfer runs immediately instead of on the selected date.")
            }
        }
        .navigationTitle("New Transfer")
        .keyboardDismissToolbar()
        .safeAreaInset(edge: .bottom) {
            PrimaryBottomButton("Review Transfer") {
                if let draft = viewModel.makeDraft() {
                    draftForRecap = draft
                }
            }
        }
        .navigationDestination(item: $draftForRecap) { draft in
            TransferRecapView(
                draft: draft,
                selectedTab: $selectedTab,
                onCompletion: {
                    viewModel.reset()
                }
            )
        }
    }

    @ViewBuilder
    private var executionDatePicker: some View {
        if let minimumDate = viewModel.minimumExecutionDate {
            DatePicker(
                "Execution date",
                selection: $viewModel.executionDate,
                in: minimumDate...,
                displayedComponents: [.date, .hourAndMinute]
            )
        } else {
            DatePicker(
                "Execution date",
                selection: $viewModel.executionDate,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
    }
}

#Preview {
    @Previewable @State var tab = AppTab.createTransfer

    NavigationStack {
        CreateTransferView(selectedTab: $tab)
    }
    .environment(AppDependencyContainer.preview)
}
