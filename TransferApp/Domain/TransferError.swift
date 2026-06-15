//
//  TransferError.swift
//  TransferApp
//

import Foundation

enum TransferError: LocalizedError {
    case networking(NetworkingError)
    case persistence(PersistenceError)
    case validation(ValidationError)
    case invalidCurrency(String)

    var errorDescription: String? {
        switch self {
        case .networking(let error):
            return error.errorDescription
        case .persistence(let error):
            return error.errorDescription
        case .validation(let error):
            return error.errorDescription
        case .invalidCurrency(let code):
            return "Unsupported currency: \(code)."
        }
    }

    static func wrap(_ error: Error) -> TransferError {
        if let transferError = error as? TransferError {
            return transferError
        }
        if let networkingError = error as? NetworkingError {
            return .networking(networkingError)
        }
        if let persistenceError = error as? PersistenceError {
            return .persistence(persistenceError)
        }
        if let validationError = error as? ValidationError {
            return .validation(validationError)
        }
        return .networking(.decodingFailed(error))
    }
}
