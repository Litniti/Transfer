//
//  DashboardViewModel.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class DashboardViewModel {
    private(set) var statistics: TransferStatistics = .empty
    private(set) var profile: UserProfile = .default
    private(set) var recentTransfers: [Transfer] = []

    private let historyStore: TransferHistoryStore
    private let profileService: UserProfileService
    private let statisticsService: TransferStatisticsService

    var isLoading: Bool { historyStore.loadState.isLoading }

    init(
        historyStore: TransferHistoryStore,
        profileService: UserProfileService,
        statisticsService: TransferStatisticsService
    ) {
        self.historyStore = historyStore
        self.profileService = profileService
        self.statisticsService = statisticsService
    }

    func load() async {
        await historyStore.loadTransfers()
        refreshPresentation()
    }

    func refreshPresentation() {
        do {
            profile = try profileService.loadProfile()
        } catch {
            profile = .default
        }
        statistics = statisticsService.compute(
            from: historyStore.transfers,
            profile: profile
        )
        recentTransfers = Array(historyStore.transfers.prefix(5))
    }
}
