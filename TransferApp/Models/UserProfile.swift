//
//  UserProfile.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct UserProfile: Codable, Equatable {
    var name: String
    var email: String
    var accountBalance: Double
    var defaultCurrency: Currency

    static let `default` = UserProfile(
        name: "Oussama Litniti",
        email: "oussama.litniti@email.com",
        accountBalance: 125_000,
        defaultCurrency: .MAD
    )
}
