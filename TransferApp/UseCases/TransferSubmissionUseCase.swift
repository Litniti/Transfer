//
//  TransferSubmissionUseCase.swift
//  TransferApp
//

import Foundation

struct TransferSubmissionUseCase: TransferSubmitting {
    let persistenceService: TransferPersistenceService

    func submitTransfer(from draft: TransferDraft) async throws -> Transfer {
        try await execute(from: draft)
    }

    func execute(from draft: TransferDraft) async throws -> Transfer {
        try await Task.sleep(for: .milliseconds(800))

        let transfer = try draft.makeTransfer(status: .completed)
        var savedTransfers = try persistenceService.loadSavedTransfers()
        savedTransfers.insert(transfer, at: 0)
        try persistenceService.saveTransfers(savedTransfers)
        return transfer
    }
}
