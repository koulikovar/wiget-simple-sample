import Foundation

public protocol WidgetDataManager {
    func lastSaved() -> WidgetData?
    func save(_ widgetData: WidgetData)
}

final class WidgetDataManagerImpl: WidgetDataManager {
    private let storage: UserDefaults? = {
        UserDefaults(suiteName: "group.moveapps.moveup")
    }()
    
    func lastSaved() -> WidgetData? {
        guard
            let rawData = storage?.object(forKey: .widgetDataKey) as? Data,
            let widgetData = try? JSONDecoder().decode(WidgetData.self, from: rawData)
        else {
            return nil
        }
        
        return widgetData
    }
    
    func save(_ widgetData: WidgetData) {
        if let data = try? JSONEncoder().encode(widgetData) {
            storage?.set(data, forKey: .widgetDataKey)
        }
    }
}
private extension String {
    static let widgetDataKey = "WidgetCore.WidgetData.Storage.Key"
}
