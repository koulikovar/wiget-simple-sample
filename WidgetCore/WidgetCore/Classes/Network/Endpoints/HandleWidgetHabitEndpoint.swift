import Foundation

public struct HandleWidgetHabitEndpoint: WidgetEndpoint {
    // MARK: - Private
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    public init(
        date: Date,
        habitInstanceId: Int,
        isComplete: Bool
    ) {
        self.parameters = [
            "for_day": self.dateFormatter.string(from: date),
            "habit_instance_id": habitInstanceId,
            "is_completed": isComplete
        ]
    }
    
    // MARK: - Public
    
    public let path: String = "/v2/habits/complete"
    public let method: WidgetHTTPMethod = .post
    public let parameters: Parameters?
}
