//
//  TransferHistoryView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferHistoryView: View {
    @Environment(TransferHistoryStore.self) private var historyStore
    @State private var viewModel = TransferHistoryViewModel()

    private var filteredTransfers: [Transfer] {
        viewModel.filteredTransfers(from: historyStore.transfers)
    }

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

            case .loaded where filteredTransfers.isEmpty:
                ContentUnavailableView {
                    Label("No Results", systemImage: "magnifyingglass")
                } description: {
                    Text("Try adjusting your search or filters.")
                } actions: {
                    Button("Clear Filters") { viewModel.clearFilters() }
                }

            default:
                ScrollView {
                    VStack(spacing: AppSpacing.sm) {
                        if let warning = historyStore.loadState.warning {
                            Label(
                                warning.errorDescription ?? "Some data could not be refreshed.",
                                systemImage: "exclamationmark.triangle"
                            )
                            .font(AppFonts.caption)
                            .foregroundStyle(AppColors.warningOrange)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppSpacing.md)
                            .background(AppColors.warningOrange.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.buttonRadius))
                        }

                        statusFilterChips

                        ForEach(filteredTransfers) { transfer in
                            NavigationLink(value: transfer) {
                                TransferRow(transfer: transfer, showsChevron: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(AppSpacing.md)
                }
                .refreshable {
                    await historyStore.loadTransfers()
                }
            }
        }
        .themedBackground()
        .navigationTitle("History")
        .searchable(text: $viewModel.searchText, prompt: "Search beneficiary or reason")
        .navigationDestination(for: Transfer.self) { transfer in
            TransferDetailView(transfer: transfer)
        }
        .task {
            await historyStore.loadTransfers()
        }
    }

    private var statusFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.xs) {
                filterChip(title: "All", isSelected: viewModel.selectedStatusFilter == nil) {
                    viewModel.selectedStatusFilter = nil
                }
                ForEach(TransferStatus.allCases) { status in
                    filterChip(
                        title: status.displayName,
                        isSelected: viewModel.selectedStatusFilter == status
                    ) {
                        viewModel.selectedStatusFilter = status
                    }
                }
            }
        }
    }

    private func filterChip(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption.weight(.semibold))
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(isSelected ? AppColors.primaryBlue : AppColors.cardBackground)
                .foregroundStyle(isSelected ? .white : AppColors.secondaryText)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        }
        .accessibilityLabel("\(title) filter")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    NavigationStack {
        TransferHistoryView()
            .environment(AppDependencyContainer.preview.historyStore)
    }
}
