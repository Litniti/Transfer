//
//  LocalJSONNetworkingService.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

final class LocalJSONNetworkingService: NetworkingService {
    private let resourceName: String
    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(resourceName: String = "transfers", bundle: Bundle = .main) {
        self.resourceName = resourceName
        self.bundle = bundle

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func fetchTransfers() async throws -> [Transfer] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw NetworkingError.resourceNotFound
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw NetworkingError.invalidData
        }

        do {
            return try decoder.decode([Transfer].self, from: data)
        } catch {
            throw NetworkingError.decodingFailed(error)
        }
    }
}
