//
//  HomeView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var session: SessionController
    @Environment(\.modelContext) private var context
    @State private var isEditingBalance = false
    @State private var newBalanceText: String = ""

    var body: some View {
        if let user = session.currentUser {
            VStack(spacing: 30) {
                Text("Welcome back, \(user.username)!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Balance")
                        .font(.headline)
                        .foregroundColor(.gray)

                    if isEditingBalance {
                        HStack {
                            TextField("Enter new balance", text: $newBalanceText)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)

                            Button("Save") {
                                if let newBalance = Double(newBalanceText) {
                                    user.balance = newBalance
                                    try? context.save()
                                    isEditingBalance = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        HStack {
                            Text("Rp \(user.balance ?? 0.0, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.medium)

                            Spacer()

                            Button("Edit") {
                                newBalanceText = String(user.balance ?? 0.0)
                                isEditingBalance = true
                            }
                            .font(.footnote)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                Spacer()

                Button(action: {
                    session.logout()
                }) {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .padding()
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}


#Preview {
    let dummyUser = UserModel(userId: 1, username: "steven", password: "123", balance: 0.0)
    let dummySession = SessionController()
    dummySession.login(user: dummyUser)
    return HomeView()
        .environmentObject(dummySession)
        .modelContainer(for: UserModel.self, inMemory: true)
}

