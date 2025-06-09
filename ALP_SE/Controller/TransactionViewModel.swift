//
//  TransactionController.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 30/05/25.
//

import Foundation
import SwiftData

@MainActor
class TransactionViewModel: ObservableObject {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func insertDefaultCategoriesIfNeeded(currentCategories: [CategoryModel]) {
        let defaultNames = ["Food", "Transportation", "Shopping", "Health", "Donation", "Investment", "Others"]
        let existingNames = Set(currentCategories.map { $0.name })

        for (index, name) in defaultNames.enumerated() where !existingNames.contains(name) {
            let newCategory = CategoryModel(categoryId: index + 1, name: name, type: .expense)
            context.insert(newCategory)
        }

        try? context.save()
    }

    func addTransaction(user: UserModel, category: CategoryModel?, amountText: String, date: Date, notes: String) throws {
        guard let category = category else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please select a category"])
        }

        guard let amount = Double(amountText) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Amount must be numeric"])
        }

        let transaction = TransactionModel(
            transactionId: Int.random(in: 1000...9999),
            amount: amount,
            date: date,
            notes: notes,
            userModel: user,
            category: category,
            savingGoal: nil
        )

        context.insert(transaction)

        if category.type == .expense {
            user.balance = (user.balance ?? 0) - amount
        } else {
            user.balance = (user.balance ?? 0) + amount
        }

        try context.save()
    }
}
