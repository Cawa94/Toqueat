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

    static func updateWith(user: BaseResultWithIdAndName, city: City) {
        guard let token = SessionService.session?.authToken
            else { return }
        SessionService.session = UserSession(authToken: token,
                                             city: city,
                                             user: user)
        NavigationService.reloadMainTabControllers()
    }

    static var isLoggedIn: Bool {
        return session != nil
    }

    static func logout() {
        SessionService.session = nil
        CartService.localCart = nil
        NavigationService.reloadMainTabControllers()
    }

}
