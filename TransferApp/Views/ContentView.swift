//
//  ContentView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppDependencyContainer.self) private var dependencies
    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(AppTab.dashboard)

            NavigationStack {
                CreateTransferView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Transfer", systemImage: "paperplane.fill")
            }
            .tag(AppTab.transfer)

            NavigationStack {
                TransferHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
            .tag(AppTab.history)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(AppTab.profile)
        }
        .tint(AppColors.primaryBlue)
        .environment(dependencies.historyStore)
        .preferredColorScheme(dependencies.appearanceStore.colorScheme)
    }
}

#Preview {
    ContentView()
        .environment(AppDependencyContainer.preview)
}
