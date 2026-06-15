//
//  TransferFormValidation.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct TransferFormValidation {
    static let minimumIBANLength = 15

    static func minimumExecutionDate(isInstant: Bool, referenceDate: Date = Date()) -> Date? {
        isInstant ? nil : referenceDate
    }

    static func validate(
        beneficiary: String,
        iban: String,
        amountText: String,
        reason: String,
        executionDate: Date,
        isInstant: Bool,
        referenceDate: Date = Date()
    ) -> [TransferFormField: ValidationError] {
        var errors: [TransferFormField: ValidationError] = [:]

        let trimmedBeneficiary = beneficiary.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedBeneficiary.isEmpty {
            errors[.beneficiary] = .beneficiaryRequired
        }

        let trimmedIBAN = iban.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedIBAN.isEmpty {
            errors[.iban] = .ibanRequired
        } else if trimmedIBAN.count < minimumIBANLength {
            errors[.iban] = .ibanTooShort(minimumLength: minimumIBANLength)
        }

        let trimmedAmount = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAmount.isEmpty {
            errors[.amount] = .amountRequired
        } else if let value = Double(trimmedAmount.replacingOccurrences(of: ",", with: ".")) {
            if value <= 0 {
                errors[.amount] = .amountNotPositive
            }
        } else {
            errors[.amount] = .amountInvalid
        }

        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedReason.isEmpty {
            errors[.reason] = .reasonRequired
        }

        if isInstant == false, executionDate < referenceDate {
            errors[.executionDate] = .executionDateInPast
        }

        return errors
    }

    static func validateDraft(
        _ draft: TransferDraft,
        referenceDate: Date = Date()
    ) throws {
        let errors = validate(
            beneficiary: draft.beneficiary,
            iban: draft.iban,
            amountText: String(draft.amount),
            reason: draft.reason,
            executionDate: draft.executionDate,
            isInstant: draft.isInstant,
            referenceDate: referenceDate
        )

        if let firstError = errors.values.first {
            throw firstError
        }
    }

    static func parsedAmount(from amountText: String) -> Double? {
        let normalized = amountText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value > 0 else { return nil }
        return value
    }
}
