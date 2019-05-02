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

    static func addToCart(_ dish: LocalCartDish, chef: BaseChef? = nil) {
        guard let cart = localCart
            else {
                NavigationService.makeLoginRootController()
                return
            }
        var newDishes = cart.dishes ?? []
        newDishes.append(dish)
        localCart = cart.copyWith(dishes: newDishes, chef: chef)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        NavigationService.animateBasketItem()
    }

    static func removeFromCart(_ dish: LocalCartDish) {
        guard let cart = localCart, let dishes = cart.dishes,
        let dishToRemove = dishes.enumerated().first(where: { $0.element.id == dish.id })
            else { return }
        var newDishes = dishes
        newDishes.remove(at: dishToRemove.offset)
        localCart = cart.copyWith(dishes: newDishes, chef: localCart?.chef)
    }

    static func clearCart() {
        guard let cart = localCart
            else { return }
        localCart = cart.copyWith(dishes: [])
    }

}
