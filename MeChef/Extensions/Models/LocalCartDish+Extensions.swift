import Foundation
import RxSwift
import RxCocoa

extension LocalCartDish {

    var imageLink: URL? {
        if let imageUrl = imageUrl {
            return URL(string: "\(NetworkService.baseUrl)\(imageUrl.dropFirst())")
        } else {
            return nil
        }
    }

    var quantityInCart: Int {
        guard let cart = CartService.localCart, let dishes = cart.dishes
            else { return 0 }
        return dishes.filter { $0.id == self.id }.count
    }

    func canAddToCart() -> Bool {
        if quantityInCart < maxQuantity {
            return true
        }
        return false
    }

    func canRemoveFromCart() -> Bool {
        if quantityInCart > 0 {
            return true
        }
        return false
    }

    var canAddDriver: Driver<Bool> {
        return CartService.canAddDriver(for: id)
    }

}

extension LocalCartDish: Equatable {

    static func == (lhs: LocalCartDish, rhs: LocalCartDish) -> Bool {
        return lhs.id == rhs.id
    }

}
