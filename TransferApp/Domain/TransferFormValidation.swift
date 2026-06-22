//
//  TransferFormValidation.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct TransferFormValidation {
    static let minimumIBANLength = 15
    static let minimumBeneficiaryLength = 2
    static let maximumTransferAmount = 1_000_000.0

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
        } else if trimmedBeneficiary.count < minimumBeneficiaryLength {
            errors[.beneficiary] = .beneficiaryTooShort(minimumLength: minimumBeneficiaryLength)
        }

        let normalizedIBAN = normalizeIBAN(iban)
        if normalizedIBAN.isEmpty {
            errors[.iban] = .ibanRequired
        } else if normalizedIBAN.count < minimumIBANLength {
            errors[.iban] = .ibanTooShort(minimumLength: minimumIBANLength)
        } else if isValidIBANFormat(normalizedIBAN) == false {
            errors[.iban] = .ibanInvalidFormat
        }

        let trimmedAmount = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAmount.isEmpty {
            errors[.amount] = .amountRequired
        } else if let value = parsedAmount(from: trimmedAmount) {
            if value <= 0 {
                errors[.amount] = .amountNotPositive
            } else if value > maximumTransferAmount {
                errors[.amount] = .amountExceedsLimit(maximum: maximumTransferAmount)
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

    static func normalizeIBAN(_ iban: String) -> String {
        iban
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .uppercased()
    }

    static func isValidIBANFormat(_ normalizedIBAN: String) -> Bool {
        normalizedIBAN.range(of: "^[A-Z0-9]+$", options: .regularExpression) != nil
    }
}
