//
//  TransferAppApp.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

@main
struct TransferAppApp: App {
    @State private var dependencies = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dependencies)
        }
    }
}
