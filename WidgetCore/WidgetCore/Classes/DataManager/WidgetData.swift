import Foundation

public struct WidgetData: Codable {
    public var state: State
    public var habits: WidgetHabits
    
    public init(state: State, habits: WidgetHabits) {
        self.state = state
        self.habits = habits
    }
}

public extension WidgetData {
    /// This enum represents whether the widget data was delivered into Widget.
    enum State: Codable {
        case pending
        case delivered
    }
}

extension WidgetData: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.habits == rhs.habits
    }
}
