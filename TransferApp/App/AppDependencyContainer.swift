//
//  AppDependencyContainer.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppDependencyContainer {
    let historyStore: TransferHistoryStore
    let submissionUseCase: TransferSubmissionUseCase
    let profileService: UserProfileService
    let statisticsService: TransferStatisticsService
    let appearanceStore: AppAppearanceStore

    init(
        networkingService: NetworkingService = LocalJSONNetworkingService(),
        persistenceService: TransferPersistenceService = UserDefaultsTransferPersistenceService(),
        profileService: UserProfileService = UserDefaultsUserProfileService()
    ) {
        self.profileService = profileService
        self.statisticsService = TransferStatisticsService()
        self.appearanceStore = AppAppearanceStore()
        historyStore = TransferHistoryStore(
            networkingService: networkingService,
            persistenceService: persistenceService
        )
        submissionUseCase = TransferSubmissionUseCase(persistenceService: persistenceService)
    }

    func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            historyStore: historyStore,
            profileService: profileService,
            statisticsService: statisticsService
        )
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            profileService: profileService,
            appearanceStore: appearanceStore
        )
    }

    static let preview = AppDependencyContainer()
}
