//
//  SavingEntryModel.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

@Model
class SavingEntryModel {
    var savingEntryId: Int
    var amount: Double
    var date: Date
    var note: String
    @Relationship var savingGoalModel: SavingGoalModel

    init(savingEntryId: Int, amount: Double, date: Date, note: String, savingGoalModel: SavingGoalModel) {
        self.savingEntryId = savingEntryId
        self.amount = amount
        self.date = date
        self.note = note
        self.savingGoalModel = savingGoalModel
    }
}
