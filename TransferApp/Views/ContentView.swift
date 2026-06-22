//
//  ContentView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppDependencyContainer.self) private var dependencies
    @State private var selectedTab: AppTab = .createTransfer

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                CreateTransferView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("New Transfer", systemImage: "plus.circle")
            }
            .tag(AppTab.createTransfer)

            NavigationStack {
                TransferHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
            .tag(AppTab.history)
        }
        .environment(dependencies.historyStore)
    }
}

#Preview {
    ContentView()
        .environment(AppDependencyContainer.preview)
}
