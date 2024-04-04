import Foundation

public enum WidgetNetworkServiceAssembly {
    public static func build() -> WidgetNetworkService {
        WidgetNetworkServiceImpl(
            baseURL: .prod,
            authTokenManager: WidgetAuthTokenManagerAssembly.build()
        )
    }
}
