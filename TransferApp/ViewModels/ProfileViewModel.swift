//
//  ProfileViewModel.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var profile: UserProfile = .default

    private let profileService: UserProfileService
    let appearanceStore: AppAppearanceStore

    init(profileService: UserProfileService, appearanceStore: AppAppearanceStore) {
        self.profileService = profileService
        self.appearanceStore = appearanceStore
    }

    func load() {
        do {
            profile = try profileService.loadProfile()
        } catch {
            profile = .default
        }
    }
}
