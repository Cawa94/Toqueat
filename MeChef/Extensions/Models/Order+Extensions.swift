import Foundation

extension Order {

    var localCart: LocalCart {
        let cartDishes = dishes ?? []
        return LocalCart(id: id, products: cartDishes.map { $0.id }, chefId: chef?.id)
    }

}
