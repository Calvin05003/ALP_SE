import SwiftUI
import SwiftData

@main
struct ALP_SEApp: App {
    @StateObject private var session = SessionController()
    @StateObject private var userController: UserController
    @StateObject private var goal: SavingGoalController
    @StateObject private var entry: SavingEntryController

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
        // Initialize SavingGoalController with the container's main context
        _goal = StateObject(wrappedValue: SavingGoalController(context: container.mainContext))
        _entry = StateObject(wrappedValue: SavingEntryController(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(session)
                .environmentObject(userController)   // inject UserController
                .environmentObject(goal)             // inject SavingGoalController
                .environmentObject(entry)
                .modelContainer(sharedModelContainer)
        }
    }
}
