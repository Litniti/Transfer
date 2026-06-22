//
//  TransferStatistics.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct TransferStatistics: Equatable {
    let totalTransfers: Int
    let monthlyTransferCount: Int
    let totalAmountSent: Double
    let currency: Currency
    let monthlyActivity: [MonthlyTransferActivity]
    let currentBalance: Double

    static let empty = TransferStatistics(
        totalTransfers: 0,
        monthlyTransferCount: 0,
        totalAmountSent: 0,
        currency: .MAD,
        monthlyActivity: [],
        currentBalance: UserProfile.default.accountBalance
    )
}

struct MonthlyTransferActivity: Identifiable, Equatable {
    let id: String
    let label: String
    let transferCount: Int
    let totalAmount: Double
}
