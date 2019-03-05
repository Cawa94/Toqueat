import Foundation
import RxSwift

struct SessionService {

    private static let storage = UserDefaults.standard

    private init() {
        // Singleton
    }

    static var user: UserSession? {
        get {
            return storage.userSession
        }
        set {
            storage.userSession = newValue
        }
    }

    static var isLoggedIn: Bool {
        return user != nil
    }

    static func logout() {
        user = nil
    }

}
