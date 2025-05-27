//
//  UserController.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

class UserController: ObservableObject {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func register(username: String, password: String) throws -> Bool {
        let userExists = try checkIfUserExists(username: username)
        guard !userExists else { return false }

        let allUsers = try context.fetch(FetchDescriptor<UserModel>())
        let maxUserId = allUsers.compactMap { $0.userId }.max() ?? 0
        let newUserId = maxUserId + 1

        let newUser = UserModel(userId: newUserId, username: username, password: password)
        context.insert(newUser)
        try context.save()
        return true
    }


    func login(username: String, password: String) throws -> UserModel? {
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.username == username && $0.password == password }
        )
        let users = try context.fetch(descriptor)
        return users.first
    }
    
    func checkIfUserExists(username: String) throws -> Bool {
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.username == username }
        )
        let users = try context.fetch(descriptor)
        return !users.isEmpty
    }
}

