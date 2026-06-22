//
//  TransferRecapView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferRecapView: View {
    @Environment(AppDependencyContainer.self) private var dependencies

    @Binding var selectedTab: AppTab
    @State private var viewModel: TransferRecapViewModel
    @State private var submittedTransfer: Transfer?

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
        Group {
            if let transfer = submittedTransfer {
                TransferSuccessView(
                    transfer: transfer,
                    selectedTab: $selectedTab,
                    onDone: onCompletion
                )
            } else {
                recapContent
            }
        }
        .navigationBarBackButtonHidden(submittedTransfer != nil)
    }

    private var recapContent: some View {
        List {
            Section {
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
                    title: "Execution",
                    value: viewModel.draft.isInstant
                        ? "Immediately"
                        : TransferFormatting.dateTime(viewModel.draft.executionDate)
                )
                DetailRow(
                    title: "Type",
                    value: viewModel.draft.isInstant
                        ? TransferType.instant.rawValue
                        : TransferType.scheduled.rawValue
                )
            } header: {
                Text("Summary")
            }

            if let error = viewModel.submissionState.error {
                Section {
                    FormErrorMessage(message: error.errorDescription ?? "Transfer submission failed.")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Recap")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            PrimaryBottomButton(
                title: "Confirm Transfer",
                isLoading: viewModel.submissionState.isInProgress
            ) {
                Task {
                    await viewModel.confirm(
                        using: dependencies.submissionUseCase,
                        historyStore: dependencies.historyStore
                    )
                    if let transfer = viewModel.submissionState.result {
                        submittedTransfer = transfer
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var tab = AppTab.transfer
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
