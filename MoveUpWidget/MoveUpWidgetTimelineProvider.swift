import Foundation
import SwiftUI
import WidgetCore
import WidgetKit

struct MoveUpWidgetTimelineProvider: TimelineProvider {
    // MARK: - Private
    
    private let networkService = WidgetNetworkServiceAssembly.build()
    private let widgetDataManager = WidgetDataManagerAssembly.build()
    
    // MARK: - Public
    
    func placeholder(in context: Context) -> MoveUpWidgetEntry {
        MoveUpWidgetEntry(date: Date(), state: .loaded(.placeholder))
    }

    func getSnapshot(in context: Context, completion: @escaping (MoveUpWidgetEntry) -> ()) {
        guard !context.isPreview else {
            let entry = MoveUpWidgetEntry(date: Date(), state: .loaded(.placeholder))
            completion(entry)
            return
        }
        
        if let deliveredTimeline = self.lastDeliveredTimeline(Date()),
           let firstEntry = deliveredTimeline.entries.first {
            completion(firstEntry)
        } else {
            Task {
                let timeline = await self.timelineFromNetwork(Date())
                let entry = timeline.entries.first ?? MoveUpWidgetEntry(date: Date(), state: .loaded(.placeholder))
                
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoveUpWidgetEntry>) -> ()) {
        let nextRefreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        
        self.timeline(with: nextRefreshDate, completion: completion)
    }
}

// MARK: - Private extensions

private extension MoveUpWidgetTimelineProvider {
    func timeline(with nextRefreshDate: Date, completion: @escaping (Timeline<MoveUpWidgetEntry>) -> ()) {
        if let pendingTimeline = self.pendingTimeline(nextRefreshDate) {
            completion(pendingTimeline)
        } else {
            Task {
                let timeline = await self.timelineFromNetwork(nextRefreshDate)
                completion(timeline)
            }
        }
    }
    
    func timelineFromNetwork(_ nextRefreshDate: Date) async -> Timeline<MoveUpWidgetEntry> {
        do {
            let habits: WidgetHabits = try await self.networkService.performRequest(for: GetWidgetDataEndpoint())
            
            // It's important to save it as delivered. Pending state supposed to be set only from the App.
            widgetDataManager.save(WidgetData(state: .delivered, habits: habits))
            
            return Timeline(
                entries: [
                    MoveUpWidgetEntry(date: Date(), state: .loaded(habits)),
                    MoveUpWidgetEntry(date: nextRefreshDate, state: .loaded(habits)),
                ],
                policy: .atEnd
            )
        } catch {
            let timeline: Timeline<MoveUpWidgetEntry>
            switch error {
            case WidgetNetworkError.unauthorizedAccess:
                timeline = Timeline(
                    entries: [MoveUpWidgetEntry(date: Date(), state: .error(LocalizedStringKey("widget.error.unauthorized")))],
                    policy: .after(nextRefreshDate)
                )
            default:
                if let lastDeliveredTimeline = self.lastDeliveredTimeline(nextRefreshDate) {
                    timeline = lastDeliveredTimeline
                } else {
                    timeline = Timeline(
                        entries: [MoveUpWidgetEntry(date: Date(), state: .error(LocalizedStringKey("widget.error.something.went.wrong")))],
                        policy: .after(nextRefreshDate)
                    )
                }
            }
            
            return timeline
        }
    }
    
    func pendingTimeline(_ nextRefreshDate: Date) -> Timeline<MoveUpWidgetEntry>? {
        guard 
            var lastSavedWidgetData = widgetDataManager.lastSaved(),
            lastSavedWidgetData.state == .pending
        else {
            return nil
        }
        
        lastSavedWidgetData.state = .delivered
        widgetDataManager.save(lastSavedWidgetData)
        
        return Timeline(
            entries: [
                MoveUpWidgetEntry(date: Date(), state: .loaded(lastSavedWidgetData.habits)),
                MoveUpWidgetEntry(date: nextRefreshDate, state: .loaded(lastSavedWidgetData.habits)),
            ],
            policy: .atEnd
        )
    }
    
    func lastDeliveredTimeline(_ nextRefreshDate: Date) -> Timeline<MoveUpWidgetEntry>? {
        guard
            let lastSavedWidgetData = widgetDataManager.lastSaved(),
            lastSavedWidgetData.state == .delivered
        else {
            return nil
        }
        
        return Timeline(
            entries: [
                MoveUpWidgetEntry(date: Date(), state: .loaded(lastSavedWidgetData.habits)),
                MoveUpWidgetEntry(date: nextRefreshDate, state: .loaded(lastSavedWidgetData.habits)),
            ],
            policy: .atEnd
        )
    }
}

// MARK: - Localized placeholder data mock

public extension WidgetHabits {
    static let placeholder = WidgetHabits(
        data: Data(
            habitInstances: [
                WidgetHabits.Data.Instance(
                    id: 0,
                    icon: ":books:",
                    name: NSLocalizedString("widget.placeholder.habit.reading.books", comment: ""),
                    totalToDo: 1,
                    totalCompleted: 0,
                    sort: 10
                ),
                WidgetHabits.Data.Instance(
                    id: 1,
                    icon: ":meditation:",
                    name: NSLocalizedString("widget.placeholder.habit.meditation", comment: ""),
                    totalToDo: 1,
                    totalCompleted: 0,
                    sort: 20
                ),
                WidgetHabits.Data.Instance(
                    id: 2,
                    icon: ":water_faucet:",
                    name: NSLocalizedString("widget.placeholder.habit.drinking.water", comment: ""),
                    totalToDo: 5,
                    totalCompleted: 3,
                    sort: 30
                ),
                WidgetHabits.Data.Instance(
                    id: 3,
                    icon: ":strong:",
                    name: NSLocalizedString("widget.placeholder.habit.morning.routine", comment: ""),
                    totalToDo: 1,
                    totalCompleted: 1,
                    sort: 40
                )
            ],
            streakCount: 5
        )
    )
}
