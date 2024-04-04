import SwiftUI
import WidgetKit
import WidgetCore

struct MoveUpWidgetEntry: TimelineEntry {
    let date: Date
    let state: State
}

extension MoveUpWidgetEntry {
    enum State {
        case loaded(WidgetHabits)
        case error(LocalizedStringKey)
    }
}
