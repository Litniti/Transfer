//
//  AppDependencyContainer.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

/// Composition root for the application. Wires services, stores, and use cases once.
@Observable
@MainActor
final class AppDependencyContainer {
    let historyStore: TransferHistoryStore
    let submissionUseCase: TransferSubmissionUseCase

    init(
        networkingService: NetworkingService = LocalJSONNetworkingService(),
        persistenceService: TransferPersistenceService = UserDefaultsTransferPersistenceService()
    ) {
        historyStore = TransferHistoryStore(
            networkingService: networkingService,
            persistenceService: persistenceService
        )
        submissionUseCase = TransferSubmissionUseCase(persistenceService: persistenceService)
    }

    static let preview = AppDependencyContainer()
}
