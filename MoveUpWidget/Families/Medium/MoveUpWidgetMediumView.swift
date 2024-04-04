import SwiftUI
import WidgetKit
import WidgetCore

struct MoveUpWidgetMediumView : View {
    // MARK: - Private
    
    private let entry: MoveUpWidgetEntry
    
    // MARK: - Lifecycle
    
    init(entry: MoveUpWidgetEntry) {
        self.entry = entry
    }
    
    // MARK: - Body

    var body: some View {
        switch self.entry.state {
        case .loaded(let habits):
            HabitsDashboardView(habits: habits, date: self.entry.date)
        case .error(let localizedStringKey):
            ErrorView(errorMessage: localizedStringKey)
        }
        
    }
}


// MARK: - Preview

struct MoveUpWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
        MoveUpWidgetMediumView(
            entry: MoveUpWidgetEntry(
                date: Date(),
                state: .loaded(.mock)
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
