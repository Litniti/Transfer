//
//  UserProfileService.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

protocol UserProfileService {
    func loadProfile() throws -> UserProfile
    func saveProfile(_ profile: UserProfile) throws
}

final class UserDefaultsUserProfileService: UserProfileService {
    private let defaults: UserDefaults
    private let storageKey: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard, storageKey: String = "userProfile") {
        self.defaults = defaults
        self.storageKey = storageKey
    }

    func loadProfile() throws -> UserProfile {
        guard let data = defaults.data(forKey: storageKey) else {
            return .default
        }
        return try decoder.decode(UserProfile.self, from: data)
    }

    func saveProfile(_ profile: UserProfile) throws {
        let data = try encoder.encode(profile)
        defaults.set(data, forKey: storageKey)
    }
}
