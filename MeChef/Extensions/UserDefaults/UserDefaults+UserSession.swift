import Foundation

private extension String {

    static let userSessionKey = "user_session"

}

extension UserDefaults {

    var userSession: UserSession? {
        get {
            return try? object(forKey: .userSessionKey)
        }
        set {
            set(model: newValue, forKey: .userSessionKey)
        }
    }

}
