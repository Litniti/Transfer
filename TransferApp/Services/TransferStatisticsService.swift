//
//  TransferStatisticsService.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct TransferStatisticsService {
    func compute(from transfers: [Transfer], profile: UserProfile) -> TransferStatistics {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now

        let completedTransfers = transfers.filter { $0.status == .completed }
        let monthlyTransfers = transfers.filter { $0.createdAt >= startOfMonth }

        let totalSent = completedTransfers.reduce(0) { $0 + $1.amount }
        let balance = max(0, profile.accountBalance - totalSent)

        let monthlyActivity = buildMonthlyActivity(from: transfers, calendar: calendar)

        return TransferStatistics(
            totalTransfers: transfers.count,
            monthlyTransferCount: monthlyTransfers.count,
            totalAmountSent: totalSent,
            currency: profile.defaultCurrency,
            monthlyActivity: monthlyActivity,
            currentBalance: balance
        )
    }

    private func buildMonthlyActivity(
        from transfers: [Transfer],
        calendar: Calendar
    ) -> [MonthlyTransferActivity] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        var grouped: [String: (label: String, count: Int, amount: Double)] = [:]

        for transfer in transfers {
            let components = calendar.dateComponents([.year, .month], from: transfer.createdAt)
            let key = "\(components.year ?? 0)-\(components.month ?? 0)"
            let label = formatter.string(from: transfer.createdAt)
            var entry = grouped[key] ?? (label: label, count: 0, amount: 0)
            entry.count += 1
            if transfer.status == .completed {
                entry.amount += transfer.amount
            }
            grouped[key] = entry
        }

        return grouped
            .sorted { $0.key < $1.key }
            .suffix(6)
            .map { key, value in
                MonthlyTransferActivity(
                    id: key,
                    label: value.label,
                    transferCount: value.count,
                    totalAmount: value.amount
                )
            }
    }
}
