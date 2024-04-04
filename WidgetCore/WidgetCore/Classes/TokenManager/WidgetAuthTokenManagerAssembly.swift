import Foundation

public enum WidgetAuthTokenManagerAssembly {
    public static func build() -> WidgetAuthTokenManager {
        WidgetAuthTokenManagerImpl()
    }
}
