//
//  TransferHistoryViewModel.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class TransferHistoryViewModel {
    var searchText = ""
    var selectedStatusFilter: TransferStatus?

    func filteredTransfers(from transfers: [Transfer]) -> [Transfer] {
        transfers.filter { transfer in
            let matchesSearch = searchText.isEmpty
                || transfer.beneficiary.localizedCaseInsensitiveContains(searchText)
                || transfer.reason.localizedCaseInsensitiveContains(searchText)
                || transfer.iban.localizedCaseInsensitiveContains(searchText)

            let matchesStatus = selectedStatusFilter == nil
                || transfer.status == selectedStatusFilter

            return matchesSearch && matchesStatus
        }
    }

    func clearFilters() {
        searchText = ""
        selectedStatusFilter = nil
    }
}
