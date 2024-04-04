import Foundation

// MARK: - WidgetHabits

public struct WidgetHabits: Codable, Equatable {
    public var data: WidgetHabits.Data
    
    public init(data: WidgetHabits.Data) {
        self.data = data
    }
}

// MARK: - Data

public extension WidgetHabits {
    struct Data: Codable, Equatable {
        public var habitInstances: [Instance]
        public var streakCount: Int

        enum CodingKeys: String, CodingKey {
            case habitInstances = "habit_instances"
            case streakCount = "streak_count"
        }
        
        public init(habitInstances: [Instance], streakCount: Int) {
            self.habitInstances = habitInstances
            self.streakCount = streakCount
        }
    }
}

// MARK: - Instance

public extension WidgetHabits.Data {
    struct Instance: Codable, Equatable, Sendable {
        public let id: Int
        public let icon: String
        public let name: String
        public let totalToDo: Int
        public var totalCompleted: Int
        public let sort: Int
        
        public var isCompleted: Bool {
            self.totalToDo == self.totalCompleted
        }

        enum CodingKeys: String, CodingKey {
            case id
            case icon
            case name
            case totalToDo = "today_items_count"
            case totalCompleted = "today_completed_items_count"
            case sort
        }
        
        public init(
            id: Int,
            icon: String,
            name: String,
            totalToDo: Int,
            totalCompleted: Int,
            sort: Int
        ) {
            self.id = id
            self.icon = icon
            self.name = name
            self.totalToDo = totalToDo
            self.totalCompleted = totalCompleted
            self.sort = sort
        }
    }
}

// MARK: - Mock

public extension WidgetHabits {
    static let mock = WidgetHabits(
        data: Data(
            habitInstances: [
                WidgetHabits.Data.Instance(
                    id: 0,
                    icon: ":gift:",
                    name: "Планировать следующий день",
                    totalToDo: 1,
                    totalCompleted: 0,
                    sort: 10
                ),
                WidgetHabits.Data.Instance(
                    id: 1,
                    icon: ":pensil:",
                    name: "Общаться с людьми через социальные сети",
                    totalToDo: 1,
                    totalCompleted: 0,
                    sort: 20
                ),
                WidgetHabits.Data.Instance(
                    id: 2,
                    icon: ":cool_sunglasses:",
                    name: "Отдыхать с ближайшими в течение 10 минут",
                    totalToDo: 5,
                    totalCompleted: 0,
                    sort: 30
                ),
                WidgetHabits.Data.Instance(
                    id: 3,
                    icon: ":pensil:",
                    name: "Сделать 10 минут упражнений для здоровья",
                    totalToDo: 1,
                    totalCompleted: 0,
                    sort: 40
                )
            ],
            streakCount: 224
        )
    )
}
