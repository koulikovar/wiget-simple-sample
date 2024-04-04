import Foundation
import Security

public protocol WidgetAuthTokenManager {
    func saveUserId(_ userId: String)
    func deleteUserId()
    
    func authToken() -> String?
    func lastSavedUserId() -> String?
}

final class WidgetAuthTokenManagerImpl: WidgetAuthTokenManager {
    // MARK: - Private
    
    private let storage: UserDefaults? = {
        UserDefaults(suiteName: "group.moveapps.moveup")
    }()
    
    // MARK: - Public Methods
    
    func saveUserId(_ userId: String) {
        storage?.set(userId, forKey: .userIdKey)
    }
    
    func authToken() -> String? {
        guard let userId = self.lastSavedUserId() else {
            return nil
        }
        
        return .tokenPrefix + userId
    }
    
    func lastSavedUserId() -> String? {
        storage?.string(forKey: .userIdKey)
    }
    
    func deleteUserId() {
        storage?.removeObject(forKey: .userIdKey)
    }
}

private extension String {
    static let userIdKey = "WidgetCore.UserId.Storage.Key"
    static let tokenPrefix = "wdgt_S67&2#0_"
}
