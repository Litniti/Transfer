//
//  ContentView.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CreateTransferView()
            }
            .tabItem {
                Label("New Transfer", systemImage: "plus.circle")
            }

            NavigationStack {
                TransferHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(TransferHistoryStore(
            networkingService: LocalJSONNetworkingService(),
            persistenceService: UserDefaultsTransferPersistenceService()
        ))
}
