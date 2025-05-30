//
//  SavingGoalController.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 31/05/25.
//

import Foundation
import SwiftData

@MainActor
class SavingGoalController: ObservableObject {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func addSavingGoal(
        title: String,
        target: Double,
        dueDate: Date,
        user: UserModel
    ) {
        let newGoal = SavingGoalModel(
            savingGoalId: Int.random(in: 1000...9999),
            title: title,
            target: target,
            currentAmount: 0.0,
            dueDate: dueDate,
            userModel: user
        )
        
        context.insert(newGoal)
        try? context.save()
    }
    
    func deleteSavingGoal(_ goal: SavingGoalModel) {
        context.delete(goal)
        try? context.save()
    }

}
