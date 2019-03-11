import Foundation
import RxSwift

struct CartService {

    private static let storage = UserDefaults.standard
    private static let disposeBag = DisposeBag()

    private init() {
        // Singleton
    }

    static var localCart: Order? {
        get {
            return storage.localCart
        }
        set {
            storage.localCart = newValue
        }
    }

    static func getCartOrCreateNew() {
        guard let userId = SessionService.session?.user?.id
            else { return }
        NetworkService.shared.getCartWith(id: userId)
            .subscribe(onSuccess: { cart in
                localCart = cart
                debugPrint("CART ID: \(localCart?.id ?? -1)")
            }, onError: { _ in
                createNewCart()
            })
            .disposed(by: disposeBag)
    }

    static func createNewCart() {
        guard let userId = SessionService.session?.user?.id
            else { return }
        NetworkService.shared.createNewCartWith(userId: userId)
            .subscribe(onSuccess: { cart in
                localCart = cart
                debugPrint("NEWCART ID: \(localCart?.id ?? -1)")
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

    static func addToCart(product: BaseResultWithIdAndName) {
        guard let cart = localCart
            else { return }
        var newProducts = cart.products
        newProducts.append(product)
        localCart = cart.copyWith(products: newProducts)
    }

}
