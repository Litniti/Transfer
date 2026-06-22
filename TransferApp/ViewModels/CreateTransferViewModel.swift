//
//  CreateTransferViewModel.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class CreateTransferViewModel {
    var beneficiary = ""
    var iban = ""
    var amount = ""
    var currency: Currency = .MAD
    var reason = ""
    var executionDate = Date()
    var isInstant = false
    var fieldErrors: [TransferFormField: ValidationError] = [:]
    var didAttemptValidation = false

    var isFormValid: Bool {
        fieldErrors.isEmpty && parsedAmount != nil
    }

    var minimumExecutionDate: Date? {
        TransferFormValidation.minimumExecutionDate(isInstant: isInstant)
    }

    private var parsedAmount: Double? {
        TransferFormValidation.parsedAmount(from: amount)
    }

    func validate() -> Bool {
        didAttemptValidation = true
        fieldErrors = TransferFormValidation.validate(
            beneficiary: beneficiary,
            iban: iban,
            amountText: amount,
            reason: reason,
            executionDate: executionDate,
            isInstant: isInstant
        )
        return fieldErrors.isEmpty
    }

    func makeDraft() -> TransferDraft? {
        guard validate(), let amountValue = parsedAmount else { return nil }
        return TransferDraft(
            beneficiary: beneficiary,
            iban: iban,
            amount: amountValue,
            currency: currency,
            reason: reason,
            executionDate: executionDate,
            isInstant: isInstant
        )
    }

    func reset() {
        beneficiary = ""
        iban = ""
        amount = ""
        currency = .MAD
        reason = ""
        executionDate = Date()
        isInstant = false
        fieldErrors = [:]
        didAttemptValidation = false
    }

    func errorMessage(for field: TransferFormField) -> String? {
        guard didAttemptValidation else { return nil }
        return fieldErrors[field]?.errorDescription
    }

    func clearError(for field: TransferFormField) {
        fieldErrors.removeValue(forKey: field)
        if fieldErrors.isEmpty {
            didAttemptValidation = false
        }
    }
}
