//
//  DashboardView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(AppDependencyContainer.self) private var dependencies
    @Binding var selectedTab: AppTab
    @State private var viewModel: DashboardViewModel?

    var body: some View {
        Group {
            if let viewModel {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        BalanceCard(
                            balance: viewModel.statistics.currentBalance,
                            currency: viewModel.statistics.currency,
                            userName: viewModel.profile.name.components(separatedBy: " ").first ?? viewModel.profile.name
                        )

                        statsGrid(viewModel.statistics)

                        if viewModel.statistics.monthlyActivity.isEmpty == false {
                            activityChart(viewModel.statistics.monthlyActivity)
                        }

                        quickActions

                        recentTransfersSection(viewModel)
                    }
                    .padding(AppSpacing.md)
                }
                .refreshable {
                    await viewModel.load()
                }
            } else {
                ProgressView("Loading dashboard...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Dashboard")
        .themedBackground()
        .task {
            if viewModel == nil {
                viewModel = dependencies.makeDashboardViewModel()
            }
            await viewModel?.load()
        }
        .onChange(of: dependencies.historyStore.transfers.count) {
            viewModel?.refreshPresentation()
        }
    }

    private func statsGrid(_ stats: TransferStatistics) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
            InfoCard(
                title: "Monthly Transfers",
                value: "\(stats.monthlyTransferCount)",
                icon: "arrow.left.arrow.right",
                accentColor: AppColors.primaryBlue
            )
            InfoCard(
                title: "Total Sent",
                value: TransferFormatting.amount(stats.totalAmountSent, currency: stats.currency),
                icon: "chart.line.uptrend.xyaxis",
                accentColor: AppColors.successGreen
            )
            InfoCard(
                title: "All Transfers",
                value: "\(stats.totalTransfers)",
                icon: "list.bullet.rectangle",
                accentColor: AppColors.warningOrange
            )
            InfoCard(
                title: "Currency",
                value: stats.currency.rawValue,
                icon: "dollarsign.circle",
                accentColor: AppColors.primaryBlue
            )
        }
    }

    private func activityChart(_ activity: [MonthlyTransferActivity]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Monthly Activity")
            Chart(activity) { item in
                BarMark(
                    x: .value("Month", item.label),
                    y: .value("Transfers", item.transferCount)
                )
                .foregroundStyle(AppColors.primaryBlue.gradient)
                .cornerRadius(4)
            }
            .frame(height: 180)
            .padding(AppSpacing.md)
            .cardStyle()
            .accessibilityLabel("Monthly transfer activity chart")
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Quick Actions")
            HStack(spacing: AppSpacing.sm) {
                quickActionButton(title: "Send Money", icon: "paperplane.fill") {
                    selectedTab = .transfer
                }
                quickActionButton(title: "History", icon: "clock.arrow.circlepath") {
                    selectedTab = .history
                }
            }
        }
    }

    private func quickActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(AppFonts.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .cardStyle()
            .foregroundStyle(AppColors.primaryBlue)
        }
        .accessibilityLabel(title)
    }

    @ViewBuilder
    private func recentTransfersSection(_ viewModel: DashboardViewModel) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Recent Transfers", actionTitle: "See All") {
                selectedTab = .history
            }

            if viewModel.recentTransfers.isEmpty {
                emptyRecentState
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.recentTransfers) { transfer in
                        TransferRow(transfer: transfer)
                    }
                }
            }
        }
    }

    private var emptyRecentState: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "tray")
                .font(.title2)
                .foregroundStyle(AppColors.secondaryText)
            Text("No transfers yet")
                .font(AppFonts.callout)
                .foregroundStyle(AppColors.secondaryText)
            PrimaryButton(title: "Make a Transfer", action: { selectedTab = .transfer })
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
        .cardStyle()
    }
}

#Preview {
    @Previewable @State var tab = AppTab.dashboard
    NavigationStack {
        DashboardView(selectedTab: $tab)
            .environment(AppDependencyContainer.preview)
    }
}
