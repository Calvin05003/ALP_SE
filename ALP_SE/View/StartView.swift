//
//  StartView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftData
import SwiftUI

struct StartView: View {
    @EnvironmentObject var session: SessionViewModel

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

    let session = SessionViewModel()
    let userViewModel = UserViewModel(context: container.mainContext)

    StartView()
        .environmentObject(session)
        .environmentObject(userViewModel)
        .modelContainer(container)
}
