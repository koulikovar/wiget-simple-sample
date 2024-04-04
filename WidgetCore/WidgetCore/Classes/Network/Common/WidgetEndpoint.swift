import Foundation

public protocol WidgetEndpoint {
    typealias Parameters = [String: Any]
    typealias Headers = [String: String]
    
    var path: String { get }
    var method: WidgetHTTPMethod { get }
    var parameters: Parameters? { get }
}
