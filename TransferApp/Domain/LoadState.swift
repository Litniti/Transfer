//
//  LoadState.swift
//  TransferApp
//

import Foundation

enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value, warning: TransferError? = nil)
    case failed(TransferError)

    var value: Value? {
        if case .loaded(let value, _) = self {
            return value
        }
        return nil
    }

    var warning: TransferError? {
        if case .loaded(_, let warning) = self {
            return warning
        }
        return nil
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var error: TransferError? {
        if case .failed(let error) = self {
            return error
        }
        return nil
    }
}
