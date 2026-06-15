//
//  ValidationError.swift
//  TransferApp
//

import Foundation

enum TransferFormField: String, CaseIterable {
    case beneficiary
    case iban
    case amount
    case reason
    case executionDate
}

enum ValidationError: Hashable, LocalizedError {
    case beneficiaryRequired
    case ibanRequired
    case ibanTooShort(minimumLength: Int)
    case amountRequired
    case amountInvalid
    case amountNotPositive
    case reasonRequired
    case executionDateInPast

    var field: TransferFormField {
        switch self {
        case .beneficiaryRequired:
            return .beneficiary
        case .ibanRequired, .ibanTooShort:
            return .iban
        case .amountRequired, .amountInvalid, .amountNotPositive:
            return .amount
        case .reasonRequired:
            return .reason
        case .executionDateInPast:
            return .executionDate
        }
    }

    var errorDescription: String? {
        switch self {
        case .beneficiaryRequired:
            return "Beneficiary name is required."
        case .ibanRequired:
            return "IBAN is required."
        case .ibanTooShort(let minimumLength):
            return "IBAN must be at least \(minimumLength) characters."
        case .amountRequired:
            return "Amount is required."
        case .amountInvalid:
            return "Enter a valid amount."
        case .amountNotPositive:
            return "Amount must be greater than 0."
        case .reasonRequired:
            return "Transfer reason is required."
        case .executionDateInPast:
            return "Execution date must be in the future for scheduled transfers."
        }
    }
}
