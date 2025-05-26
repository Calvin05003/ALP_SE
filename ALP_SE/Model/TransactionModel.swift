//
//  TransactionModel.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

@Model
class TransactionModel {
    var transactionId: Int
    var amount: Double
    var date: Date
    var notes: String
    var category: CategoryModel?
    var savingGoal: SavingGoalModel?
    
    @Relationship var userModel: UserModel

    init(transactionId: Int, amount: Double, date: Date, notes: String, userModel: UserModel, category: CategoryModel?, savingGoal: SavingGoalModel?) {
        self.transactionId = transactionId
        self.amount = amount
        self.date = date
        self.notes = notes
        self.userModel = userModel
        self.category = category
        self.savingGoal = savingGoal
    }
}
