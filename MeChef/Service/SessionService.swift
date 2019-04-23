import Foundation
import RxSwift

struct SessionService {

    private static let storage = UserDefaults.standard

    private init() {
        // Singleton
    }

    static var session: UserSession? {
        get {
            return storage.userSession
        }
        set {
            storage.userSession = newValue
        }
    }

    static var isChef: Bool {
        return session?.chef != nil
    }

    static func updateWith(user: User) {
        guard let token = SessionService.session?.authToken
            else { return }
        SessionService.session = UserSession(authToken: token,
                                             user: user,
                                             chef: nil)
    }

    static func updateWith(chef: Chef) {
        guard let token = SessionService.session?.authToken
            else { return }
        SessionService.session = UserSession(authToken: token,
                                             user: nil,
                                             chef: chef)
    }

    static var isLoggedIn: Bool {
        return session != nil
    }

    static func logout() {
        session = nil
        CartService.localCart = nil
    }

}
