//
//  TransferPersistenceService.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

protocol TransferPersistenceService {
    func loadSavedTransfers() throws -> [Transfer]
    func saveTransfers(_ transfers: [Transfer]) throws
}

enum PersistenceError: LocalizedError {
    case encodingFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to save transfer history."
        case .decodingFailed:
            return "Failed to load saved transfers."
        }
    }
}

final class UserDefaultsTransferPersistenceService: TransferPersistenceService {
    private let defaults: UserDefaults
    private let storageKey: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = "savedTransfers"
    ) {
        self.defaults = defaults
        self.storageKey = storageKey

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
    }

    func loadSavedTransfers() throws -> [Transfer] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try decoder.decode([Transfer].self, from: data)
        } catch {
            throw PersistenceError.decodingFailed
        }
    }

    func saveTransfers(_ transfers: [Transfer]) throws {
        do {
            let data = try encoder.encode(transfers)
            defaults.set(data, forKey: storageKey)
        } catch {
            throw PersistenceError.encodingFailed
        }
    }
}
