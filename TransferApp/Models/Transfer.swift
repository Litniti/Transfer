//
//  Transfer.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//


import Foundation

struct Transfer: Identifiable, Codable {
    let id: UUID
    let recipientName: String
    let iban: String
    let amount: Double
    let reason: String
    let date: Date
    let status: TransferStatus
}

enum TransferStatus: String, Codable {
    case pending
    case completed
    case failed
}
