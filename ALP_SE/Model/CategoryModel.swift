//
//  CategoryModel.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

enum CategoryType: String, Codable {
    case income, expense
}

@Model
class CategoryModel {
    var categoryId: Int
    var name: String
    var type: CategoryType
    @Relationship var transactions: [TransactionModel] = []

    init(categoryId: Int, name: String, type: CategoryType) {
        self.categoryId = categoryId
        self.name = name
        self.type = type
    }
}
