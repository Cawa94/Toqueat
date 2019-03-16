import Foundation
import RxSwift
import RxCocoa

struct CartService {

    private static let storage = UserDefaults.standard
    private static let disposeBag = DisposeBag()

    private init() {
        // Singleton
    }

    static private let localCartVariable = Variable<LocalCart?>(storage.localCart)

    static var localCart: LocalCart? {
        get {
            return localCartVariable.value
        }
        set {
            localCartVariable.value = newValue
            storage.localCart = newValue
        }
    }

    static var localCartDriver: Driver<LocalCart?> {
        return localCartVariable.asDriver()
    }

    static var localCartObservable: Observable<LocalCart?> {
        return localCartVariable.asObservable()
    }

    static func addToCart(_ dish: LocalCartDish, chefId: Int64) {
        guard let cart = localCart
            else { return }
        var newDishes = cart.dishes ?? []
        newDishes.append(dish)
        localCart = cart.copyWith(dishes: newDishes, chefId: chefId)
    }

    static func removeFromCart(_ dish: LocalCartDish) {
        guard let cart = localCart
            else { return }
        var newDishes = cart.dishes ?? []
        newDishes.removeAll(where: { $0.id == dish.id })
        localCart = cart.copyWith(dishes: newDishes, chefId: localCart?.chefId)
    }

    static func clearCart() {
        guard let cart = localCart
            else { return }
        localCart = cart.copyWith(dishes: [])
    }

}
