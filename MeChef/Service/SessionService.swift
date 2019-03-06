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

    static func updateWith(city: City) {
        SessionService.user = UserSession(authToken: SessionService.user?.authToken ?? "",
                                          city: city)
        NavigationService.reloadMainTabControllers()
    }

    static var isLoggedIn: Bool {
        return user != nil
    }

    static func logout() {
        SessionService.user = nil
        NavigationService.reloadMainTabControllers()
    }

}
