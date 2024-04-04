import SwiftUI
import WidgetCore
import WidgetKit

extension MoveUpWidgetMediumView {
    struct HabitsDashboardView: View {
        // MARK: - Private
        
        @Environment(\.colorScheme) private var colorScheme
        
        private let habits: WidgetHabits
        private let date: Date
        
        private var totalHabits: Int {
            self.habits.data.habitInstances.count
        }
        
        private var completedHabits: Int {
            self.habits.data.habitInstances.filter({ $0.isCompleted }).count
        }
        
        private var streakDayValue: String {
            .localizedStringWithFormat(
                NSLocalizedString("numberOfDays", comment: ""),
                self.habits.data.streakCount
            )
        }
        
        private var listOffsetY: CGFloat {
            guard totalHabits > 4 else { return 0 }
            
            let itemHeight: CGFloat = 20
            let itemSpacing: CGFloat = 12
            
            let offset = completedHabits == totalHabits ? 4 : 2
            
            return min(0, -CGFloat(self.completedHabits - offset) * (itemHeight + itemSpacing))
        }
        
        // MARK: - Lifecycle
        
        init(
            habits: WidgetHabits,
            date: Date
        ) {
            self.habits = habits
            self.date = date
        }
        
        // MARK: - Body
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(self.habits.data.streakCount)")
                            .font(Typography.h2)
                            .foregroundColor(Color("mediumWidgetTextPrimaryColor"))
                        Text("\(self.streakDayValue)")
                            .font(Typography.formLabel)
                            .foregroundColor(Color("mediumWidgetTextPrimaryColor"))
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Text("\(self.completedHabits)")
                            .font(Typography.h3)
                            .foregroundColor(Color("counterPrimary"))
                        Text("/\(self.totalHabits)")
                            .font(Typography.h3)
                            .foregroundColor(Color("counterSecondary"))
                    }
                    Text(LocalizedStringKey("widget.today.title"))
                        .font(Typography.link)
                        .foregroundColor(Color("counterPrimary"))
                }
                Spacer(minLength: 34)
                Rectangle()
                    .fill(.clear)
                    .overlay(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(
                                self.habits.data.habitInstances.sortedBySortAndCompleted,
                                id: \.id
                            ) { habit in
                                HabitView(habit: habit, date: self.date)
                                    .tag(habit.id)
                            }
                        }
                        .offset(y: self.listOffsetY)
                    }
            }
            .containerBackgroundForWidget {
                Color("mediumWidgetBackground")
                    .environment(\.colorScheme, self.colorScheme)
            }
        }
    }
}

// MARK: - Habits Sorting mechanic

private extension Array where Element == WidgetHabits.Data.Instance {
    var sortedBySortAndCompleted: Self {
        let completed = self.filter({ $0.isCompleted }).sorted(by: { ($0.sort, $0.id) < ($1.sort, $1.id) })
        let todo = self.filter({ !$0.isCompleted }).sorted(by: { ($0.sort, $0.id) < ($1.sort, $1.id) })
        
        return completed + todo
    }
}

struct HabitsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MoveUpWidgetMediumView.HabitsDashboardView(
            habits: .mock,
            date: Date()
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
