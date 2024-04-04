import Foundation

public enum WidgetNetworkError: LocalizedError {
    case unauthorizedAccess
    case invalidBaseURL
    case invalidBodyParameters
    case invalidResponse(statusCode: Int)
    case responseDecodingFailed(error: Error)
    
    public var errorDescription: String? {
        switch self {
        case .unauthorizedAccess:
            return "WidgetNetworkService: Unauthorized access."
        case .invalidBaseURL:
            return "WidgetNetworkService: Invalid BaseURL has been provided."
        case .invalidBodyParameters:
            return "WidgetNetworkService: Invalid body parameters. Couldn't serialize to JSON."
        case .invalidResponse(let statusCode):
            return "WidgetNetworkService: Unexpected response with status code: \(statusCode)"
        case .responseDecodingFailed(let error):
            return "WidgetNetworkService: Response decoding has been failed with error: \(error.localizedDescription)"
        }
    }
}
