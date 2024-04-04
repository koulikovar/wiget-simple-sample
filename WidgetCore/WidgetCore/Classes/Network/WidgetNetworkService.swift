import Foundation

public protocol WidgetNetworkService  {
    func performRequest<T: Decodable>(for endpoint: WidgetEndpoint) async throws -> T
}

final class WidgetNetworkServiceImpl: WidgetNetworkService {
    // MARK: - Private
    
    private let baseURL: WidgetBaseURL
    private let authTokenManager: WidgetAuthTokenManager
    
    // MARK: - Lifecycle
    
    init(
        baseURL: WidgetBaseURL,
        authTokenManager: WidgetAuthTokenManager
    ) {
        self.baseURL = baseURL
        self.authTokenManager = authTokenManager
    }
    
    // MARK: - Public
    
    func performRequest<T: Decodable>(for endpoint: WidgetEndpoint) async throws -> T {
        let request = try endpoint.urlRequest(from: self.baseURL, authToken: self.authTokenManager.authToken())
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard 
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            switch statusCode {
            case 401:
                throw WidgetNetworkError.unauthorizedAccess
            default:
                throw WidgetNetworkError.invalidResponse(statusCode: statusCode)
            }
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw WidgetNetworkError.responseDecodingFailed(error: error)
        }
    }
}

// MARK: - Private extensions

private extension WidgetEndpoint {
    func urlRequest(
        from baseUrl: WidgetBaseURL,
        authToken: String?
    ) throws -> URLRequest {
        guard let authToken else {
            throw WidgetNetworkError.unauthorizedAccess
        }
        
        guard let host = URL(string: baseUrl.rawValue) else {
            throw WidgetNetworkError.invalidBaseURL
        }
        
        var request = URLRequest(url: host.appending(path: self.path))
        request.httpMethod = self.method.rawValue
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        if let parameters = self.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw WidgetNetworkError.invalidBodyParameters
            }
        }
        
        return request
    }
}
