//
//  AddSavingEntryView.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 03/06/25.
//
import SwiftUI

struct AddSavingEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var entry: SavingEntryController
    @EnvironmentObject var session: SessionController
    let goal: SavingGoalModel
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add to \"\(goal.title)\"")) {
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                }
                
                Button("Save Entry") {
                    if let amount = Double(amountText) {
                        do {
                            try entry.addSavingEntry(amount: amount, savingGoal: goal)
                            
                            if let user = session.currentUser {
                                if let currentBalance = user.balance {
                                    user.balance = currentBalance - amount
                                } else {
                                    // Handle if balance is nil, e.g., set it to negative amount or 0 - amount
                                    user.balance = -amount
                                }
                            }

                            dismiss()
                        } catch {
                            // Handle the error gracefully
                            print("Error adding saving entry: \(error.localizedDescription)")
                        }
                    }

                }
                .disabled(amountText.isEmpty)
            }
            .navigationTitle("Add Saving Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
