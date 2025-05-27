//
//  UserModel.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

@Model
class UserModel {
    @Attribute(.unique) var userId: Int? = nil
    var username: String
    var password: String
    var balance: Double? = 0.0
    @Relationship var transactions: [TransactionModel] = []
    @Relationship var savingGoals: [SavingGoalModel] = []

    init(userId: Int, username: String, password: String, balance: Double = 0.0) {
        self.userId = userId
        self.username = username
        self.password = password
        self.balance = balance
    }
}
