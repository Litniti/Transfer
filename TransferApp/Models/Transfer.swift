//
//  Transfer.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation

struct Transfer: Identifiable, Codable, Hashable {
    let id: String
    let beneficiary: String
    let iban: String
    let amount: Double
    let currency: Currency
    let reason: String
    let status: TransferStatus
    let createdAt: Date
    let executionDate: Date
    let isInstant: Bool

    var transferType: TransferType {
        isInstant ? .instant : .scheduled
    }

    enum CodingKeys: String, CodingKey {
        case id, beneficiary, rib, amount, currency, reason, status, createdAt
        case executionDate, isInstant
    }

    init(
        id: String = UUID().uuidString,
        beneficiary: String,
        iban: String,
        amount: Double,
        currency: Currency,
        reason: String,
        status: TransferStatus,
        createdAt: Date = Date(),
        executionDate: Date,
        isInstant: Bool
    ) {
        self.id = id
        self.beneficiary = beneficiary
        self.iban = iban
        self.amount = amount
        self.currency = currency
        self.reason = reason
        self.status = status
        self.createdAt = createdAt
        self.executionDate = executionDate
        self.isInstant = isInstant
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        beneficiary = try container.decode(String.self, forKey: .beneficiary)
        iban = try container.decode(String.self, forKey: .rib)
        amount = try container.decode(Double.self, forKey: .amount)

        let currencyCode = try container.decode(String.self, forKey: .currency)
        guard let currency = Currency(rawValue: currencyCode) else {
            throw TransferError.invalidCurrency(currencyCode)
        }
        self.currency = currency

        reason = try container.decode(String.self, forKey: .reason)
        status = try container.decode(TransferStatus.self, forKey: .status)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        executionDate = try container.decodeIfPresent(Date.self, forKey: .executionDate) ?? createdAt
        isInstant = try container.decodeIfPresent(Bool.self, forKey: .isInstant) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(beneficiary, forKey: .beneficiary)
        try container.encode(iban, forKey: .rib)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency.rawValue, forKey: .currency)
        try container.encode(reason, forKey: .reason)
        try container.encode(status, forKey: .status)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(executionDate, forKey: .executionDate)
        try container.encode(isInstant, forKey: .isInstant)
    }
}

enum TransferStatus: String, Codable, CaseIterable, Identifiable {
    case completed = "Completed"
    case pending = "Pending"
    case failed = "Failed"

    var id: String { rawValue }

    var displayName: String { rawValue }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw {
        case Self.completed.rawValue:
            self = .completed
        case Self.failed.rawValue:
            self = .failed
        default:
            self = .pending
        }
    }
}

enum TransferType: String, CaseIterable {
    case instant = "Instant"
    case scheduled = "Scheduled"
}

enum Currency: String, CaseIterable, Identifiable, Codable {
    case MAD
    case EUR
    case USD
    case GBP

    var id: String { rawValue }
}

struct TransferDraft: Hashable {
    var beneficiary: String
    var iban: String
    var amount: Double
    var currency: Currency
    var reason: String
    var executionDate: Date
    var isInstant: Bool

    func makeTransfer(status: TransferStatus = .pending) throws -> Transfer {
        try TransferFormValidation.validateDraft(self)

        return Transfer(
            beneficiary: beneficiary.trimmingCharacters(in: .whitespacesAndNewlines),
            iban: iban.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            currency: currency,
            reason: reason.trimmingCharacters(in: .whitespacesAndNewlines),
            status: status,
            executionDate: isInstant ? Date() : executionDate,
            isInstant: isInstant
        )
    }
}
