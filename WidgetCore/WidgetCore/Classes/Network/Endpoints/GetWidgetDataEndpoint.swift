import Foundation

public struct GetWidgetDataEndpoint: WidgetEndpoint {
    // MARK: - Private
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    public init(date: Date = Date()) {
        self.parameters = ["today": self.dateFormatter.string(from: date)]
    }
    
    // MARK: - Public
    
    public let path: String = "/v1/widget/habits"
    public let method: WidgetHTTPMethod = .post
    public let parameters: Parameters?
}
