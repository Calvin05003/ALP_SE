//
//  StartView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftData
import SwiftUI

struct StartView: View {
    @EnvironmentObject var session: SessionController

    var body: some View {
        NavigationStack {
            if session.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for:
            UserModel.self,
        TransactionModel.self,
        CategoryModel.self,
        SavingGoalModel.self,
        SavingEntryModel.self
    )

    let session = SessionController()
    let userController = UserController(context: container.mainContext)

    StartView()
        .environmentObject(session)
        .environmentObject(userController)
        .modelContainer(container)
}
