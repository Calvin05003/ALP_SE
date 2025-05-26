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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserModel.self,
            TransactionModel.self,
            SavingGoalModel.self,
            SavingEntryModel.self,
            CategoryModel.self
        ])
        let config = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(session)
        }
        .modelContainer(sharedModelContainer)
    }
}
