//
//  TransferRecapView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferRecapView: View {
    @Environment(AppDependencyContainer.self) private var dependencies
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedTab: AppTab
    @State private var viewModel: TransferRecapViewModel
    @State private var showSuccessAlert = false

    let onCompletion: () -> Void

    init(
        draft: TransferDraft,
        selectedTab: Binding<AppTab>,
        onCompletion: @escaping () -> Void
    ) {
        _selectedTab = selectedTab
        _viewModel = State(initialValue: TransferRecapViewModel(draft: draft))
        self.onCompletion = onCompletion
    }

    var body: some View {
        List {
            Section("Summary") {
                DetailRow(title: "Beneficiary", value: viewModel.draft.beneficiary)
                DetailRow(title: "IBAN", value: viewModel.draft.iban)
                DetailRow(
                    title: "Amount",
                    value: TransferFormatting.amount(
                        viewModel.draft.amount,
                        currency: viewModel.draft.currency
                    )
                )
                DetailRow(title: "Reason", value: viewModel.draft.reason)
                DetailRow(
                    title: "Execution date",
                    value: viewModel.draft.isInstant
                        ? "Immediately"
                        : TransferFormatting.dateTime(viewModel.draft.executionDate)
                )
                DetailRow(
                    title: "Transfer type",
                    value: viewModel.draft.isInstant
                        ? TransferType.instant.rawValue
                        : TransferType.scheduled.rawValue
                )
            }

            if let error = viewModel.submissionState.error {
                Section {
                    FormErrorMessage(message: error.errorDescription ?? "Transfer submission failed.")
                }
            }
        }
        .navigationTitle("Recap")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            PrimaryBottomButton(
                "Confirm Transfer",
                isLoading: viewModel.submissionState.isInProgress
            ) {
                Task {
                    await viewModel.confirm(
                        using: dependencies.submissionUseCase,
                        historyStore: dependencies.historyStore
                    )
                    if viewModel.submissionState.result != nil {
                        showSuccessAlert = true
                    }
                }
            }
        }
        .alert("Transfer Submitted", isPresented: $showSuccessAlert) {
            Button("View History") {
                onCompletion()
                dismiss()
                selectedTab = .history
            }
            Button("Create Another", role: .cancel) {
                onCompletion()
                dismiss()
            }
        } message: {
            Text("Your transfer has been submitted and saved to history.")
        }
    }
}

#Preview {
    @Previewable @State var tab = AppTab.createTransfer

    NavigationStack {
        TransferRecapView(
            draft: TransferDraft(
                beneficiary: "John Doe",
                iban: "MA6400112345678901234567890",
                amount: 2500,
                currency: .MAD,
                reason: "Rent",
                executionDate: Date(),
                isInstant: false
            ),
            selectedTab: $tab,
            onCompletion: {}
        )
        .environment(AppDependencyContainer.preview)
    }
}
