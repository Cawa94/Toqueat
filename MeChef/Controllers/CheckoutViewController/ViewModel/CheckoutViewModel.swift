import Foundation

struct CheckoutViewModel {

    var cart: LocalCart

}

extension CheckoutViewModel {

    var chefId: Int64? {
        return cart.chefId
    }

    var elements: [LocalCartDish] {
        return cart.dishes ?? []
    }

    func elementAt(_ index: Int) -> LocalCartDish {
        return elements[index]
    }

}
