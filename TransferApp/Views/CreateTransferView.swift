//
//  CreateTransferView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct CreateTransferView: View {
    @State private var viewModel = CreateTransferViewModel()
    @State private var draftForRecap: TransferDraft?

    var body: some View {
        Form {
            Section("Beneficiary") {
                TextField("Beneficiary name", text: $viewModel.beneficiary)
                    .textContentType(.name)
                    .autocorrectionDisabled()

                if let error = viewModel.errorMessage(for: .beneficiary) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Section("Account") {
                TextField("IBAN", text: $viewModel.iban)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()

                if let error = viewModel.errorMessage(for: .iban) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Section("Amount") {
                TextField("Amount", text: $viewModel.amount)
                    .keyboardType(.decimalPad)

                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue).tag(currency)
                    }
                }

                if let error = viewModel.errorMessage(for: .amount) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            Section("Details") {
                TextField("Transfer reason", text: $viewModel.reason)
                    .autocorrectionDisabled()

                if let error = viewModel.errorMessage(for: .reason) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                if viewModel.isInstant {
                    Text("Instant transfers are executed immediately.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    executionDatePicker

                    if let error = viewModel.errorMessage(for: .executionDate) {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Toggle("Instant transfer", isOn: $viewModel.isInstant)
            }
        }
        .navigationTitle("New Transfer")
        .safeAreaInset(edge: .bottom) {
            Button("Review Transfer") {
                if let draft = viewModel.makeDraft() {
                    draftForRecap = draft
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.bar)
        }
        .navigationDestination(item: $draftForRecap) { draft in
            TransferRecapView(draft: draft, onCompletion: {
                viewModel.reset()
            })
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
    NavigationStack {
        CreateTransferView()
    }
}
