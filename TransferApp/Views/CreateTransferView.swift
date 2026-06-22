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
            Section {
                TextField("Beneficiary name", text: $viewModel.beneficiary)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.beneficiary) { viewModel.clearError(for: .beneficiary) }
                if let error = viewModel.errorMessage(for: .beneficiary) {
                    FormErrorMessage(message: error)
                }
            } header: {
                Text("Beneficiary")
            }

            Section {
                TextField("IBAN", text: $viewModel.iban)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.iban) { viewModel.clearError(for: .iban) }
                if let error = viewModel.errorMessage(for: .iban) {
                    FormErrorMessage(message: error)
                }
            } header: {
                Text("Account")
            }

            Section {
                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.amount) { viewModel.clearError(for: .amount) }
                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue).tag(currency)
                    }
                }
                if let error = viewModel.errorMessage(for: .amount) {
                    FormErrorMessage(message: error)
                }
            } header: {
                Text("Amount")
            }

            Section {
                TextField("Transfer reason", text: $viewModel.reason)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.reason) { viewModel.clearError(for: .reason) }
                if let error = viewModel.errorMessage(for: .reason) {
                    FormErrorMessage(message: error)
                }

                if viewModel.isInstant {
                    Text("Instant transfers are executed immediately.")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.secondaryText)
                } else {
                    executionDatePicker
                        .onChange(of: viewModel.executionDate) { viewModel.clearError(for: .executionDate) }
                    if let error = viewModel.errorMessage(for: .executionDate) {
                        FormErrorMessage(message: error)
                    }
                }

                Toggle("Instant transfer", isOn: $viewModel.isInstant)
            } header: {
                Text("Details")
            }
        }
        .scrollContentBackground(.hidden)
        .themedFormSurface()
        .navigationTitle("Transfer")
        .keyboardDismissToolbar()
        .safeAreaInset(edge: .bottom) {
            PrimaryBottomButton(title: "Review Transfer") {
                if let draft = viewModel.makeDraft() {
                    draftForRecap = draft
                }
            }
        }
        .navigationDestination(item: $draftForRecap) { draft in
            TransferRecapView(
                draft: draft,
                selectedTab: $selectedTab,
                onCompletion: { viewModel.reset() }
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
    @Previewable @State var tab = AppTab.transfer
    NavigationStack {
        CreateTransferView(selectedTab: $tab)
    }
    .environment(AppDependencyContainer.preview)
}
