//
//  LogListCellView.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct LogListCellView: View {
    let log: ExpenseLog
    var action: (() -> Void)?
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                CategoryImageView(category: log.categoryEnum)

                VStack(alignment: .leading, spacing: 8) {
                    Text(log.nameText).font(.headline)
                    if !log.noteText.isEmpty {
                        Text(log.noteText).font(.body)
                    }
                    Text(log.dateText).font(.subheadline)
                }
                Spacer()
                Text(log.amountText).font(.headline)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
