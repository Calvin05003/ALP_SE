//
//  ALP_SEApp.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI
import SwiftData

@main
struct ALP_SEApp: App {
    @StateObject private var session = SessionController()
    @StateObject private var userController: UserController

    var sharedModelContainer: ModelContainer

    init() {
        let schema = Schema([
            UserModel.self,
            TransactionModel.self,
            SavingGoalModel.self,
            SavingEntryModel.self,
            CategoryModel.self
        ])
        let config = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: [config])
        sharedModelContainer = container
        // Initialize UserController with the container's main context
        _userController = StateObject(wrappedValue: UserController(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(session)
                .environmentObject(userController)   // inject UserController here
                .modelContainer(sharedModelContainer)
        }
    }
}
