//
//  TransferAppApp.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

@main
struct TransferAppApp: App {
    private let submissionUseCase: TransferSubmissionUseCase
    @State private var historyStore: TransferHistoryStore

    init() {
        let persistenceService = UserDefaultsTransferPersistenceService()
        _historyStore = State(wrappedValue: TransferHistoryStore(
            networkingService: LocalJSONNetworkingService(),
            persistenceService: persistenceService
        ))
        submissionUseCase = TransferSubmissionUseCase(persistenceService: persistenceService)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(historyStore)
                .environment(\.transferSubmissionUseCase, submissionUseCase)
        }
    }
}

private struct TransferSubmissionUseCaseKey: EnvironmentKey {
    static let defaultValue = TransferSubmissionUseCase(
        persistenceService: UserDefaultsTransferPersistenceService()
    )
}

extension EnvironmentValues {
    var transferSubmissionUseCase: TransferSubmissionUseCase {
        get { self[TransferSubmissionUseCaseKey.self] }
        set { self[TransferSubmissionUseCaseKey.self] = newValue }
    }
}
