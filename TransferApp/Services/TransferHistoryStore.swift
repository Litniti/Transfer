//
//  TransferHistoryStore.swift
//  TransferApp
//

import Foundation
import Observation

@Observable
@MainActor
final class TransferHistoryStore {
    private(set) var loadState: LoadState<[Transfer]> = .idle

    var transfers: [Transfer] {
        loadState.value ?? []
    }

    private(set) var bundledTransferIDs: Set<String> = []

    private let networkingService: NetworkingService
    private let persistenceService: TransferPersistenceService

    init(
        networkingService: NetworkingService,
        persistenceService: TransferPersistenceService
    ) {
        self.networkingService = networkingService
        self.persistenceService = persistenceService
    }

    func loadTransfers() async {
        loadState = .loading

        do {
            let bundledTransfers = try await networkingService.fetchTransfers()
            bundledTransferIDs = Set(bundledTransfers.map(\.id))
            let savedTransfers = try persistenceService.loadSavedTransfers()
            loadState = .loaded(mergeTransfers(bundled: bundledTransfers, saved: savedTransfers))
        } catch {
            let transferError = TransferError.wrap(error)
            do {
                let cachedTransfers = try persistenceService.loadSavedTransfers()
                loadState = .loaded(cachedTransfers, warning: transferError)
            } catch {
                loadState = .failed(transferError)
            }
        }
    }

    func applySubmittedTransfer(_ transfer: Transfer) async {
        if bundledTransferIDs.contains(transfer.id) {
            await loadTransfers()
            return
        }

        guard case .loaded(let currentTransfers, let warning) = loadState else {
            await loadTransfers()
            return
        }

        var updatedTransfers = currentTransfers
        updatedTransfers.removeAll { $0.id == transfer.id }
        updatedTransfers.insert(transfer, at: 0)
        loadState = .loaded(updatedTransfers, warning: warning)
    }

    private func mergeTransfers(bundled: [Transfer], saved: [Transfer]) -> [Transfer] {
        let bundledIDs = Set(bundled.map(\.id))
        let userCreated = saved.filter { bundledIDs.contains($0.id) == false }
        return (userCreated + bundled).sorted { $0.createdAt > $1.createdAt }
    }
}
