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

    static func getCartOrCreateNew() {
        guard let userId = SessionService.session?.user?.id
            else { return }
        NetworkService.shared.getOrderWith(id: userId)
            .subscribe(onSuccess: { order in
                localCart = order.localCart
                debugPrint("CHEF ID: \(localCart?.chefId ?? -1)")
                debugPrint("CART ID: \(localCart?.id ?? -1)")
            }, onError: { _ in
                createNewCart()
            })
            .disposed(by: disposeBag)
    }

    static func createNewCart() {
        guard let userId = SessionService.session?.user?.id
            else { return }
        NetworkService.shared.createNewOrderWith(userId: userId)
            .subscribe(onSuccess: { order in
                localCart = order.localCart
                debugPrint("NEWCART ID: \(localCart?.id ?? -1)")
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

    static func addToCart(_ productId: Int64, chefId: Int64) {
        guard let cart = localCart, !cart.products.contains(where: { $0 == productId })
            else { return }
        var newProducts = cart.products
        newProducts.append(productId)
        localCart = cart.copyWith(products: newProducts, chefId: chefId)
        sendCartToServer()
    }

    static func removeFromCart(_ productId: Int64) {
        guard let cart = localCart
            else { return }
        var newProducts = cart.products
        newProducts.removeAll(where: { $0 == productId })
        localCart = cart.copyWith(products: newProducts, chefId: localCart?.chefId)
        sendCartToServer()
    }

    static func clearCart(sendToServer: Bool = false) {
        guard let cart = localCart
            else { return }
        localCart = cart.copyWith(products: [])
        if sendToServer {
            sendCartToServer()
        }
    }

    static func sendCartToServer() {
        guard let userId = SessionService.session?.user?.id,
            let products = localCart?.products,
            let chefId = localCart?.chefId
            else { return }
        NetworkService.shared.updateOrderFor(userId, with: products, chefId: chefId)
            .subscribe()
            .disposed(by: disposeBag)
    }

}
