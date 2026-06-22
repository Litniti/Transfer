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

    /// When enabled, force dark mode. When disabled, follow the system appearance.
    var colorScheme: ColorScheme? {
        isDarkModeEnabled ? .dark : nil
    }
}

struct ThemedBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.background.ignoresSafeArea())
    }
}

struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.cardRadius))
            .shadow(
                color: .black.opacity(AppColors.cardShadowOpacity(for: colorScheme)),
                radius: AppSpacing.shadowRadius,
                y: colorScheme == .dark ? 2 : 4
            )
    }
}

extension View {
    func themedBackground() -> some View {
        modifier(ThemedBackground())
    }

    func cardStyle() -> some View {
        modifier(CardStyle())
    }

    func themedListSurface() -> some View {
        self
            .scrollContentBackground(.hidden)
            .themedBackground()
            .listRowBackground(AppColors.cardBackground)
    }

    func themedFormSurface() -> some View {
        self
            .scrollContentBackground(.hidden)
            .themedBackground()
            .listRowBackground(AppColors.cardBackground)
    }
}
