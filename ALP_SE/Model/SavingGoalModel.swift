//
//  SavingGoalModel.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

@Model
class SavingGoalModel {
    var savingGoalId: Int
    var title: String
    var target: Double
    var currentAmount: Double
    var dueDate: Date
    @Relationship var userModel: UserModel
    @Relationship var entries: [SavingEntryModel] = []

    init(savingGoalId: Int, title: String, target: Double, currentAmount: Double, dueDate: Date, userModel: UserModel) {
        self.savingGoalId = savingGoalId
        self.title = title
        self.target = target
        self.currentAmount = currentAmount
        self.dueDate = dueDate
        self.userModel = userModel
    }
}
