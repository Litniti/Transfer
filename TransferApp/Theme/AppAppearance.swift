//
//  AppAppearance.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

@Observable
@MainActor
final class AppAppearanceStore {
    var isDarkModeEnabled: Bool {
        didSet { UserDefaults.standard.set(isDarkModeEnabled, forKey: storageKey) }
    }

    private let storageKey = "isDarkModeEnabled"

    init() {
        isDarkModeEnabled = UserDefaults.standard.bool(forKey: storageKey)
    }

    var colorScheme: ColorScheme? {
        isDarkModeEnabled ? .dark : .light
    }
}

struct ThemedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.background.ignoresSafeArea())
    }
}

extension View {
    func themedBackground() -> some View {
        modifier(ThemedBackground())
    }
}
