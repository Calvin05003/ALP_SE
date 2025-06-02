//
//  SavingGoalsView.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 31/05/25.
//

import SwiftUI
import SwiftData

struct SavingGoalsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var session: SessionController
    @EnvironmentObject var goal: SavingGoalController
    @EnvironmentObject var entry: SavingEntryController
    @Query(sort: \SavingGoalModel.dueDate) private var allGoals: [SavingGoalModel]

    @State private var title = ""
    @State private var target = ""
    @State private var dueDate = Date()
    @State private var showAddSavingEntry = false

    // Move filtering here
    private var userGoals: [SavingGoalModel] {
        guard let currentUserId = session.currentUser?.userId else { return [] }
        return allGoals.filter { $0.userModel.userId == currentUserId }
    }
    
    // Check if user has any unfinished goals
    private var hasUnfinishedGoals: Bool {
        return userGoals.contains { $0.currentAmount < $0.target }
    }

    // Get first unfinished goal (used in .sheet)
    private var firstUnfinishedGoal: SavingGoalModel? {
        userGoals.first { $0.currentAmount < $0.target }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Saving Goals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Add New Saving Goal
                VStack(spacing: 10) {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .disabled(hasUnfinishedGoals)

                    TextField("Target Amount", text: $target)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .disabled(hasUnfinishedGoals)

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        .disabled(hasUnfinishedGoals)

                    HStack(spacing: 10) {
                        Button("Add Goal") {
                            guard let user = session.currentUser,
                                  let targetAmount = Double(target)
                            else { return }

                            goal.addSavingGoal(
                                title: title,
                                target: targetAmount,
                                dueDate: dueDate,
                                user: user
                            )

                            // Reset fields
                            title = ""
                            target = ""
                            dueDate = Date()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(title.isEmpty || target.isEmpty || hasUnfinishedGoals)
                        
                        Button("Add Saving") {
                            showAddSavingEntry = true
                        }
                        .buttonStyle(.bordered)
                        .disabled(!hasUnfinishedGoals)
                    }
                    
                    if hasUnfinishedGoals {
                        Text("Complete your current saving goal before adding a new one")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                    } else if !userGoals.isEmpty {
                        Text("You can only have one active saving goal at a time")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                }

                Divider()

                // MARK: List Saving Goals
                if userGoals.isEmpty {
                    Text("No saving goals found.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(userGoals, id: \.savingGoalId) { goalItem in
                                GoalRowView(goal: goalItem) { goalToDelete in
                                    goal.deleteSavingGoal(goalToDelete)
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddSavingEntry) {
                if let goal = firstUnfinishedGoal {
                    AddSavingEntryView(goal: goal)
                        .environmentObject(entry)
                } else {
                    Text("No unfinished goal found.")
                        .font(.headline)
                }
            }
        }
    }
}
