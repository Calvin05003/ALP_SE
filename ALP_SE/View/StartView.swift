//
//  StartView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI
import SwiftData

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
    let session = SessionController()
    
    return StartView()
        .environmentObject(session)
        .modelContainer(for: [
            UserModel.self,
            TransactionModel.self,
            CategoryModel.self,
            SavingGoalModel.self,
            SavingEntryModel.self
        ], inMemory: true)
}
