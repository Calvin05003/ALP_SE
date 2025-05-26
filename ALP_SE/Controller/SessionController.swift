//
//  SessionController.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import Foundation
import SwiftData

@MainActor
class SessionController: ObservableObject {
    @Published var currentUser: UserModel? = nil
    @Published var isLoggedIn: Bool = false

    func login(user: UserModel) {
        currentUser = user
        isLoggedIn = true
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
}
