//
//  SectionHeader.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.headline)
                .foregroundStyle(.primary)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(AppFonts.callout)
                    .foregroundStyle(AppColors.primaryBlue)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
