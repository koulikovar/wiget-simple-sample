import AppIntents
import WidgetCore
import WidgetKit

struct HandleHabitAppIntent: AppIntent {
    // MARK: - Private
    
    @Parameter(title: "Date of completion")
    private var date: Date
    
    @Parameter(title: "Desired habit")
    private var habitId: Int
    
    @Parameter(title: "Determines whether a habit was completed")
    private var isCompleted: Bool
    
    // MARK: - Lifecycle
    
    init() {
        self.date = Date()
        self.habitId = 0
        self.isCompleted = false
    }
    
    init(date: Date, habitId: Int, isCompleted: Bool) {
        self.date = date
        self.habitId = habitId
        self.isCompleted = isCompleted
    }
    
    // MARK: - Public
    
    static var title: LocalizedStringResource = "Complete/Uncomplete habit"
    static var description: IntentDescription? = "It will change a UI of a habit according to its completeness"
    
    func perform() async throws -> some IntentResult {
        updateLocalData()
        
        WidgetCenter.shared.reloadAllTimelines()
        
        let networkService = WidgetNetworkServiceAssembly.build()
        
        let _ = try await networkService.performRequest(
            for: HandleWidgetHabitEndpoint(
                date: self.date,
                habitInstanceId: self.habitId,
                isComplete: self.isCompleted
            )
        ) as WidgetHandleHabitResponse
        
        return .result()
    }
}

private extension HandleHabitAppIntent {
    func updateLocalData() {
        let dataManager = WidgetDataManagerAssembly.build()
        
        guard 
            var widgetData = dataManager.lastSaved(),
            let desiredIndex = widgetData.habits.data.habitInstances.firstIndex(where: { $0.id == self.habitId })
        else { return }
        
        let completedHabitsCount = widgetData.habits.data.habitInstances.filter({ $0.isCompleted }).count
        let currentCompletedCount = widgetData.habits.data.habitInstances[desiredIndex].totalCompleted
        let newCompletedCount = self.isCompleted ? currentCompletedCount + 1 : currentCompletedCount - 1
        
        let currentStreakCount = widgetData.habits.data.streakCount
        var newStreakCout = currentStreakCount
        if completedHabitsCount == 0 && newCompletedCount == widgetData.habits.data.habitInstances[desiredIndex].totalToDo {
            newStreakCout = currentStreakCount + 1
        } else if completedHabitsCount == 1 && newCompletedCount == 0 {
            newStreakCout = currentStreakCount - 1
        }
        
        widgetData.habits.data.habitInstances[desiredIndex].totalCompleted = newCompletedCount
        widgetData.habits.data.streakCount = newStreakCout
        widgetData.state = .pending
        
        dataManager.save(widgetData)
    }
}
