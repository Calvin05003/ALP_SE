import SwiftUI
import SwiftData

@main
struct ALP_SEApp: App {
    @StateObject private var session = SessionViewModel()
    @StateObject private var userViewModel: UserViewModel
    @StateObject private var goal: SavingGoalViewModel
    @StateObject private var entry: SavingEntryViewModel

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
        _userViewModel = StateObject(wrappedValue: UserViewModel(context: container.mainContext))
        // Initialize SavingGoalController with the container's main context
        _goal = StateObject(wrappedValue: SavingGoalViewModel(context: container.mainContext))
        _entry = StateObject(wrappedValue: SavingEntryViewModel(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(session)
                .environmentObject(userViewModel)   // inject UserController
                .environmentObject(goal)             // inject SavingGoalController
                .environmentObject(entry)
                .modelContainer(sharedModelContainer)
        }
    }
}
