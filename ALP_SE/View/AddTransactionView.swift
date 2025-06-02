//
//  AddTransactionView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 30/05/25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @EnvironmentObject var session: SessionController
    @EnvironmentObject var transactionController: TransactionController

    @Query private var allCategories: [CategoryModel]

    @State private var selectedCategory: CategoryModel?
    @State private var amountText = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var errorMessage: String?
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Transaction")
                .font(.title)
                .bold()

            Picker("Category", selection: $selectedCategory) {
                ForEach(allCategories) { category in
                    Text(category.name).tag(category as CategoryModel?)
                }
            }
            .pickerStyle(.menu)
            
            TextField("Amount", text: $amountText)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            TextField("Notes", text: $notes)
                .textFieldStyle(.roundedBorder)
            
            Button("Submit") {
                submitTransaction()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .onAppear {
            transactionController.insertDefaultCategoriesIfNeeded(currentCategories: allCategories)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    func submitTransaction() {
        guard let user = session.currentUser else {
            errorMessage = "User not found"
            showAlert = true
            return
        }

        do {
            try transactionController.addTransaction(
                user: user,
                category: selectedCategory,
                amountText: amountText,
                date: date,
                notes: notes
            )
            amountText = ""
            notes = ""
            selectedCategory = nil
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
}
