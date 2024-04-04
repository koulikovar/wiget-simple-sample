import Foundation

public enum WidgetDataManagerAssembly {
    public static func build() -> WidgetDataManager {
        WidgetDataManagerImpl()
    }
}
