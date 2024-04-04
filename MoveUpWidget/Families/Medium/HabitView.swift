import AppIntents
import SwiftUI
import WidgetCore
import WidgetKit

extension MoveUpWidgetMediumView.HabitsDashboardView {
    struct HabitView: View {
        // MARK: - Private
        
        private let date: Date
        private let habit: WidgetHabits.Data.Instance
        
        private var imageName: String {
            self.habit.icon.trimmingCharacters(in: CharacterSet(charactersIn: ":"))
        }
        
        private var textColorName: String {
            self.habit.isCompleted ? "mediumWidgetFillPrimary" : "mediumWidgetTextSecondaryColor"
        }
        
        private var checkboxView: some View {
            let remainingHabits = max(0, self.habit.totalToDo - self.habit.totalCompleted)
            return ZStack {
                if remainingHabits == 0 {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(Color("mediumWidgetFillPrimary"))
                } else if self.habit.totalToDo == 1 {
                    Image("habit-checkbox-unchecked")
                        .resizable()
                } else {
                    let progress = CGFloat(self.habit.totalCompleted) / CGFloat(self.habit.totalToDo)
                    ZStack {
                        Image("habit-checkbox-unchecked")
                            .resizable()
                        Arc(progress: progress)
                            .foregroundColor(Color("mediumWidgetFillPrimary"))
                    }
                }
            }
            .frame(width: 20, height: 20)
        }
         
        private func reverseCompatibleButton(_ view: () -> some View) -> Button<some View> {
            if #available(iOSApplicationExtension 17.0, *) {
                Button(
                    intent: HandleHabitAppIntent(
                        date: self.date,
                        habitId: self.habit.id,
                        isCompleted: !self.habit.isCompleted
                    )
                ) {
                    view()
                }
            } else {
                Button(action: {}) {
                    view()
                }
            }
        }
        
        // MARK: - Lifecycle
        
        init(
            habit: WidgetHabits.Data.Instance,
            date: Date
        ) {
            self.habit = habit
            self.date = date
        }
        
        // MARK: - Body
        
        var body: some View {
            self.reverseCompatibleButton {
                HStack(spacing: 4) {
                    self.checkboxView
                    HStack(spacing: 4) {
                        Image(self.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13, height: 13, alignment: .center)
                        Text(self.habit.name)
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(self.textColorName))
                    }
                    .if(self.habit.isCompleted) { view in
                        view
                            .overlay(
                                Rectangle()
                                    .foregroundColor(Color("mediumWidgetFillPrimary"))
                                    .frame(height: 2)
                            )
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Arc

private extension MoveUpWidgetMediumView.HabitsDashboardView.HabitView {
    struct Arc: Shape {
        var progress: CGFloat // Value between 0 and 1

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
                        
            let startAngle = Angle(radians: 2 * .pi * 0 - CGFloat.pi / 2)
            let endAngle = Angle(radians: 2 * .pi * Double(progress) - CGFloat.pi / 2)

            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            return path
        }
    }
}

// MARK: - Preview

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        MoveUpWidgetMediumView.HabitsDashboardView.HabitView(
            habit: WidgetHabits.Data.Instance(
                id: 0,
                icon: ":cool_sunglasses:",
                name: "Habit 1",
                totalToDo: 5,
                totalCompleted: 3,
                sort: 10
            ),
            date: Date()
        )
        .containerBackgroundForWidget {
            Color("mediumWidgetBackground")
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
