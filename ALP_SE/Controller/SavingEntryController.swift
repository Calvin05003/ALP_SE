//
//  SavingEntryController.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 03/06/25.
//

import Foundation
import SwiftData

class SavingEntryController: ObservableObject {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Add Saving Entry
    func addSavingEntry(
        amount: Double,
        date: Date = Date(),
        note: String = "",
        savingGoal: SavingGoalModel
    ) throws {
        // Generate new ID
        let newId = generateNewSavingEntryId()
        
        // Create new saving entry
        let newEntry = SavingEntryModel(
            savingEntryId: newId,
            amount: amount,
            date: date,
            note: note,
            savingGoalModel: savingGoal
        )
        
        // Add to context
        context.insert(newEntry)
        
        // Update the saving goal's current amount
        savingGoal.currentAmount += amount
        
        // Save context
        try context.save()
    }
    
    // MARK: - Delete Saving Entry
    func deleteSavingEntry(_ entry: SavingEntryModel) throws {
        // Subtract the amount from the saving goal's current amount
        entry.savingGoalModel.currentAmount -= entry.amount
        
        // Delete the entry
        context.delete(entry)
        
        // Save context
        try context.save()
    }
    
    // MARK: - Update Saving Entry
    func updateSavingEntry(
        _ entry: SavingEntryModel,
        newAmount: Double? = nil,
        newDate: Date? = nil,
        newNote: String? = nil
    ) throws {
        // If amount is being updated, adjust the saving goal's current amount
        if let newAmount = newAmount, newAmount != entry.amount {
            let difference = newAmount - entry.amount
            entry.savingGoalModel.currentAmount += difference
            entry.amount = newAmount
        }
        
        // Update other fields if provided
        if let newDate = newDate {
            entry.date = newDate
        }
        
        if let newNote = newNote {
            entry.note = newNote
        }
        
        // Save context
        try context.save()
    }
    
    // MARK: - Get Entries for Saving Goal
    func getEntriesForGoal(_ savingGoal: SavingGoalModel) -> [SavingEntryModel] {
        return savingGoal.entries.sorted { $0.date > $1.date } // Sort by date, newest first
    }
    
    // MARK: - Get Total Amount for Saving Goal
    func getTotalAmountForGoal(_ savingGoal: SavingGoalModel) -> Double {
        return savingGoal.entries.reduce(0) { total, entry in
            total + entry.amount
        }
    }
    
    // MARK: - Generate New ID
    private func generateNewSavingEntryId() -> Int {
        let descriptor = FetchDescriptor<SavingEntryModel>(sortBy: [SortDescriptor(\.savingEntryId, order: .reverse)])
        
        do {
            let entries = try context.fetch(descriptor)
            return (entries.first?.savingEntryId ?? 0) + 1
        } catch {
            print("Error fetching saving entries for ID generation: \(error)")
            return 1
        }
    }
    
    // MARK: - Validate Entry Amount
    func validateEntryAmount(_ amount: Double, for savingGoal: SavingGoalModel) -> Bool {
        let newTotal = savingGoal.currentAmount + amount
        return newTotal <= savingGoal.target && amount > 0
    }
    
    // MARK: - Get Progress Percentage
    func getProgressPercentage(for savingGoal: SavingGoalModel) -> Double {
        guard savingGoal.target > 0 else { return 0 }
        return min((savingGoal.currentAmount / savingGoal.target) * 100, 100)
    }
}
