//
//  GoalRowView.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 31/05/25.
//

import SwiftUI

struct GoalRowView: View {
    var goal: SavingGoalModel
    var deleteAction: (SavingGoalModel) -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.title)
                    .font(.headline)

                Spacer()

                Text("Rp \(goal.currentAmount, specifier: "%.0f") / Rp \(goal.target, specifier: "%.0f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text("Due: \(goal.dueDate.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(.top, 40).padding(.trailing, 15)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
        )
        .confirmationDialog("Are you sure you want to delete this goal?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteAction(goal)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
