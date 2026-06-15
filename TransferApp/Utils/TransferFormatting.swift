//
//  TransferFormatting.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

enum TransferFormatting {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func amount(_ value: Double, currency: Currency) -> String {
        amount(value, currencyCode: currency.rawValue)
    }

    static func amount(_ value: Double, currencyCode: String) -> String {
        let formatted = currencyFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return "\(formatted) \(currencyCode)"
    }

    static func dateTime(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    static func date(_ date: Date) -> String {
        dayFormatter.string(from: date)
    }
}
