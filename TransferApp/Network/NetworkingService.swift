//
//  NetworkingService.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

protocol NetworkingService {
    func fetchTransfers() async throws -> [Transfer]
}

protocol TransferSubmitting {
    func submitTransfer(from draft: TransferDraft) async throws -> Transfer
}

enum NetworkingError: LocalizedError {
    case resourceNotFound
    case invalidData
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "Transfer data could not be found."
        case .invalidData:
            return "Transfer data is invalid."
        case .decodingFailed(let error):
            return "Failed to decode transfers: \(error.localizedDescription)"
        }
    }
}
