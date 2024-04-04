import WidgetKit
import SwiftUI
import WidgetCore

struct MoveUpWidgetDark: Widget {
    // MARK: - Private
    
    private let kind: String = "MoveUpWidgetDarkKind"
    
    // MARK: - Body
    
    var body: some WidgetConfiguration {
        WidgetConfigurationProvider.configuration(for: .dark, kind: self.kind)
    }
}

struct MoveUpWidgetLight: Widget {
    // MARK: - Private
    
    private let kind: String = "MoveUpWidgetLightKind"
    
    // MARK: - Body
    
    var body: some WidgetConfiguration {
        WidgetConfigurationProvider.configuration(for: .light, kind: self.kind)
    }
}

private enum WidgetConfigurationProvider {
    static func configuration(
        for colorScheme: ColorScheme,
        kind: String
    ) -> some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: MoveUpWidgetTimelineProvider()
        ) { entry in
            MoveUpWidgetEntryView(entry: entry)
                .environment(\.colorScheme, colorScheme)
        }
        .configurationDisplayName(colorScheme == .light ? "MoveUp Widget Light" : "MoveUp Widget Dark")
        .description("MoveUp Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct MoveUpWidgetEntryView : View {
    // MARK: - Private
    
    private let entry: MoveUpWidgetEntry
    @Environment(\.widgetFamily) private var widgetFamily
    
    // MARK: - Lifecycle
    
    init(entry: MoveUpWidgetEntry) {
        self.entry = entry
    }
    
    // MARK: - Body

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            MoveUpWidgetSmallView(entry: entry)
        case .systemMedium:
            MoveUpWidgetMediumView(entry: entry)
        default: // Fallback to a small one
            MoveUpWidgetSmallView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall, widget: {
    MoveUpWidgetLight()
}, timeline: {
    MoveUpWidgetEntry(
        date: Date(),
        state: .loaded(.mock)
    )
})
