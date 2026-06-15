//
//  OperationState.swift
//  TransferApp
//

import Foundation

enum OperationState<Result> {
    case idle
    case inProgress
    case succeeded(Result)
    case failed(TransferError)

    var isInProgress: Bool {
        if case .inProgress = self {
            return true
        }
        return false
    }

    var result: Result? {
        if case .succeeded(let result) = self {
            return result
        }
        return nil
    }

    var error: TransferError? {
        if case .failed(let error) = self {
            return error
        }
        return nil
    }
}
