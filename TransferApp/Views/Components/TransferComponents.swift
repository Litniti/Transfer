//
//  TransferComponents.swift
//  TransferApp
//
//  Created by Oussama Litniti on 15/6/2026.
//

import SwiftUI

struct TransferStatusBadge: View {
    let status: TransferStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor.opacity(0.15))
            .foregroundStyle(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch status {
        case .completed:
            return .green
        case .pending:
            return .orange
        case .processing:
            return .blue
        case .failed:
            return .red
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    VStack {
        TransferStatusBadge(status: .completed)
        DetailRow(title: "Beneficiary", value: "John Doe")
    }
    .padding()
}
