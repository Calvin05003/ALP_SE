//
//  UserController.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

class UserController{
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func register(userId: Int, username: String, password: String) throws -> Bool {
        let userExists = try checkIfUserExists(username: username)
        guard !userExists else { return false }
        
        let newUser = UserModel(userId: userId, username: username, password: password, balance: 0.0)
        context.insert(newUser)
        try context.save()
        return true
    }
    
    func login(username: String, password: String) throws -> UserModel? {
        let descriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { $0.username == username && $0.password == password }
        )
        let users = try context.fetch(descriptor)
        if let user = users.first {
                context.insert(user)
            }
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
