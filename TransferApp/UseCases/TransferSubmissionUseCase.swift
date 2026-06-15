//
//  TransferSubmissionUseCase.swift
//  TransferApp
//

import Foundation

struct TransferSubmissionUseCase {
    let persistenceService: TransferPersistenceService

    func execute(from draft: TransferDraft) async throws -> Transfer {
        try await Task.sleep(for: .milliseconds(800))

        let transfer = try draft.makeTransfer(status: .completed)
        var savedTransfers = try persistenceService.loadSavedTransfers()
        savedTransfers.insert(transfer, at: 0)
        try persistenceService.saveTransfers(savedTransfers)
        return transfer
    }
}
