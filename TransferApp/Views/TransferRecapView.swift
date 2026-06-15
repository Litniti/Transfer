//
//  TransferRecapView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferRecapView: View {
    @Environment(TransferHistoryStore.self) private var historyStore
    @Environment(\.transferSubmissionUseCase) private var submissionUseCase
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: TransferRecapViewModel
    @State private var showSuccessAlert = false

    let onCompletion: () -> Void

    init(draft: TransferDraft, onCompletion: @escaping () -> Void) {
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
                    value: TransferFormatting.dateTime(viewModel.draft.executionDate)
                )
                DetailRow(
                    title: "Transfer type",
                    value: viewModel.draft.isInstant ? TransferType.instant.rawValue : TransferType.scheduled.rawValue
                )
            }

            if let error = viewModel.submissionState.error {
                Section {
                    Text(error.errorDescription ?? "Transfer submission failed.")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Recap")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    await viewModel.confirm(
                        using: submissionUseCase,
                        historyStore: historyStore
                    )
                    if viewModel.submissionState.result != nil {
                        showSuccessAlert = true
                    }
                }
            } label: {
                if viewModel.submissionState.isInProgress {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Confirm Transfer")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.submissionState.isInProgress)
            .padding()
            .background(.bar)
        }
        .alert("Transfer Submitted", isPresented: $showSuccessAlert) {
            Button("OK") {
                onCompletion()
                dismiss()
            }
        } message: {
            Text("Your transfer has been submitted and saved to history.")
        }
    }
}

#Preview {
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
            onCompletion: {}
        )
        .environment(TransferHistoryStore(
            networkingService: LocalJSONNetworkingService(),
            persistenceService: UserDefaultsTransferPersistenceService()
        ))
    }
}
