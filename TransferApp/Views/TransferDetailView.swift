//
//  TransferDetailView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferDetailView: View {
    let transfer: Transfer

    var body: some View {
        List {
            Section("Status") {
                HStack {
                    Text("Status")
                        .foregroundStyle(.secondary)
                    Spacer()
                    TransferStatusBadge(status: transfer.status)
                }
            }

            Section("Transfer Information") {
                DetailRow(title: "Beneficiary", value: transfer.beneficiary)
                DetailRow(title: "IBAN", value: transfer.iban)
                DetailRow(
                    title: "Amount",
                    value: TransferFormatting.amount(transfer.amount, currency: transfer.currency)
                )
                DetailRow(title: "Reason", value: transfer.reason)
            }

            Section("Dates") {
                DetailRow(
                    title: "Execution date",
                    value: TransferFormatting.dateTime(transfer.executionDate)
                )
                DetailRow(
                    title: "Creation date",
                    value: TransferFormatting.dateTime(transfer.createdAt)
                )
            }

            Section("Type") {
                DetailRow(title: "Transfer type", value: transfer.transferType.rawValue)
            }
        }
        .navigationTitle("Transfer Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TransferDetailView(
            transfer: Transfer(
                beneficiary: "John Doe",
                iban: "123456789012345678901234",
                amount: 2500,
                currency: .MAD,
                reason: "Rent",
                status: .completed,
                createdAt: Date(),
                executionDate: Date(),
                isInstant: false
            )
        )
    }
}
