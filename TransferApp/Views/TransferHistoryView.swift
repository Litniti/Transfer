//
//  TransferHistoryView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferHistoryView: View {
    @Environment(TransferHistoryStore.self) private var historyStore

    var body: some View {
        Group {
            switch historyStore.loadState {
            case .idle, .loading where historyStore.transfers.isEmpty:
                ProgressView("Loading transfers...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .failed(let error) where historyStore.transfers.isEmpty:
                ContentUnavailableView {
                    Label("Unable to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.errorDescription ?? "An unexpected error occurred.")
                } actions: {
                    Button("Retry") {
                        Task { await historyStore.loadTransfers() }
                    }
                }

            case .loaded where historyStore.transfers.isEmpty:
                ContentUnavailableView {
                    Label("No Transfers", systemImage: "tray")
                } description: {
                    Text("Create a transfer to see it appear here.")
                }

            default:
                List {
                    if let warning = historyStore.loadState.warning {
                        Section {
                            Label(
                                warning.errorDescription ?? "Some transfer data could not be refreshed.",
                                systemImage: "exclamationmark.triangle"
                            )
                            .font(.caption)
                            .foregroundStyle(.orange)
                        }
                    }

                    ForEach(historyStore.transfers) { transfer in
                        NavigationLink(value: transfer) {
                            TransferHistoryRow(transfer: transfer)
                        }
                    }
                }
                .refreshable {
                    await historyStore.loadTransfers()
                }
            }
        }
        .navigationTitle("History")
        .navigationDestination(for: Transfer.self) { transfer in
            TransferDetailView(transfer: transfer)
        }
        .task {
            await historyStore.loadTransfers()
        }
    }
}

private struct TransferHistoryRow: View {
    let transfer: Transfer

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transfer.beneficiary)
                    .font(.headline)
                Spacer()
                TransferStatusBadge(status: transfer.status)
            }

            Text(TransferFormatting.amount(transfer.amount, currency: transfer.currency))
                .font(.subheadline)

            Text(TransferFormatting.dateTime(transfer.createdAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        TransferHistoryView()
            .environment(TransferHistoryStore(
                networkingService: LocalJSONNetworkingService(),
                persistenceService: UserDefaultsTransferPersistenceService()
            ))
    }
}
