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
    @State private var isAddingBalance = false
    @State private var newBalanceText: String = ""
    @State private var isShowingSavingGoals = false // Sheet control
    @Query(sort: \TransactionModel.date, order: .reverse) private var allTransactions: [TransactionModel]
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
                    if isAddingBalance {
                        HStack {
                            TextField("Enter amount to add", text: $newBalanceText)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)

                            Button("Add") {
                                if let additionalAmount = Double(newBalanceText) {
                                    user.balance! += additionalAmount // <- Add instead of set
                                    try? context.save()
                                    isAddingBalance = false
                                    newBalanceText = "" // optional: clear text field after adding
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
                            Button("Add Balance") {
                                newBalanceText = String(user.balance ?? 0.0)
                                isAddingBalance = true
                            }
                            .font(.footnote)
                        }
                    }
                    // New: Sheet trigger button
                    Button {
                        isShowingSavingGoals = true
                    } label: {
                        Text("🏆 View Saving Goals")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                NavigationLink {
                    AddTransactionView()
                        .environmentObject(TransactionController(context: context))
                } label: {
                    Text("➕ Add Transaction")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Transactions")
                        .font(.headline)
                    let userTransactions = allTransactions.filter { $0.userModel.userId == user.userId }
                    if userTransactions.isEmpty {
                        Text("No transactions found.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(userTransactions.prefix(5)) { transaction in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(transaction.category?.name ?? "Unknown")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("Rp \(transaction.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                Text(transaction.notes)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(transaction.date, style: .date)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
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
            .sheet(isPresented: $isShowingSavingGoals) {
                SavingGoalsView()
            }
        }
    }
}
#Preview {
    let dummyUser = UserModel(
        userId: 1,
        username: "steven",
        password: "123",
        balance: 0.0
    )
    let dummySession = SessionController()
    dummySession.login(user: dummyUser)
    return HomeView()
        .environmentObject(dummySession)
        .modelContainer(for: [UserModel.self, TransactionModel.self, CategoryModel.self], inMemory: true)
}
