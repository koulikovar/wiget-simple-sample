import SwiftUI
import WidgetKit
import WidgetCore

struct MoveUpWidgetSmallView : View {
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
            HabitsCounterView(habits: habits)
        case .error(let localizedStringKey):
            ErrorView(errorMessage: localizedStringKey)
        }
    }
}

// MARK: - Habits view

extension MoveUpWidgetSmallView {
    struct HabitsCounterView: View {
        // MARK: - Private
        
        @Environment(\.colorScheme) private var colorScheme
        
        private let habits: WidgetHabits
        
        private var totalHabits: Int {
            self.habits.data.habitInstances.count
        }
        
        private var completedHabits: Int {
            self.habits.data.habitInstances.filter({ $0.isCompleted }).count
        }
        
        // MARK: - Lifecycle
        
        init(habits: WidgetHabits) {
            self.habits = habits
        }
        
        // MARK: - Body
        
        var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text("\(self.completedHabits)")
                        .font(Typography.cardTitle)
                        .foregroundColor(Color("counterPrimary"))
                    Text("/\(self.totalHabits)")
                        .font(Typography.cardTitle)
                        .foregroundColor(Color("counterSecondary"))
                    Spacer()
                }
                Text(LocalizedStringKey("widget.today.title"))
                    .font(Typography.link)
                    .foregroundColor(Color("counterPrimary"))
            }
            .containerBackgroundForWidget {
                Image("widget-background")
                    .resizable()
                    .scaledToFill()
                    .environment(\.colorScheme, self.colorScheme)
            }
        }
    }
}

// MARK: - Error view

extension MoveUpWidgetSmallView {
    struct ErrorView: View {
        // MARK: - Private
        
        @Environment(\.colorScheme) private var colorScheme
        
        private let errorMessage: LocalizedStringKey
        
        // MARK: - Lifecycle
        
        init(errorMessage: LocalizedStringKey) {
            self.errorMessage = errorMessage
        }
        
        // MARK: - Body
        
        var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(errorMessage)
                        .font(Typography.link)
                        .foregroundColor(Color("counterPrimary"))
                    Spacer()
                }
            }
            .containerBackgroundForWidget {
                Image("widget-background")
                    .resizable()
                    .scaledToFill()
                    .environment(\.colorScheme, self.colorScheme)
            }
        }
    }
}

// MARK: - Preview

struct MoveUpWidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        MoveUpWidgetSmallView(
            entry: MoveUpWidgetEntry(
                date: Date(),
                state: .loaded(.mock)
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
