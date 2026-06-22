//
//  TransferRecapViewModel.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class TransferRecapViewModel {
    let draft: TransferDraft

    private(set) var submissionState: OperationState<Transfer> = .idle

    init(draft: TransferDraft) {
        self.draft = draft
    }

    func confirm(
        using submissionUseCase: TransferSubmitting,
        historyStore: TransferHistoryStore
    ) async {
        guard submissionState.isInProgress == false else { return }

        submissionState = .inProgress

        do {
            let transfer = try await submissionUseCase.submitTransfer(from: draft)
            await historyStore.applySubmittedTransfer(transfer)
            submissionState = .succeeded(transfer)
        } catch {
            submissionState = .failed(TransferError.wrap(error))
        }
    }
}
