//
//  AppColors.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI
import UIKit

enum AppColors {
    static let primaryBlue = Color(red: 0.11, green: 0.35, blue: 0.85)
    static let primaryBlueDark = Color(red: 0.08, green: 0.28, blue: 0.72)
    static let successGreen = Color(red: 0.13, green: 0.70, blue: 0.45)
    static let warningOrange = Color(red: 0.95, green: 0.55, blue: 0.15)
    static let errorRed = Color(red: 0.90, green: 0.25, blue: 0.28)

    static let gradientStart = Color(red: 0.11, green: 0.35, blue: 0.85)
    static let gradientEnd = Color(red: 0.20, green: 0.50, blue: 0.95)

    static let background = adaptiveColor(
        light: UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1),
        dark: UIColor(red: 0.06, green: 0.07, blue: 0.09, alpha: 1)
    )

    static let cardBackground = adaptiveColor(
        light: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1),
        dark: UIColor(red: 0.14, green: 0.15, blue: 0.18, alpha: 1)
    )

    static let secondaryText = adaptiveColor(
        light: UIColor(red: 0.45, green: 0.48, blue: 0.55, alpha: 1),
        dark: UIColor(red: 0.62, green: 0.65, blue: 0.70, alpha: 1)
    )

    static let divider = adaptiveColor(
        light: UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1),
        dark: UIColor(red: 0.24, green: 0.25, blue: 0.28, alpha: 1)
    )

    static let elevatedBackground = adaptiveColor(
        light: UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1),
        dark: UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1)
    )

    static func cardShadowOpacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? 0.35 : 0.08
    }

    private static func adaptiveColor(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}
