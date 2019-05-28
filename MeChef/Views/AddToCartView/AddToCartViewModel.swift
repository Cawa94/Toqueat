struct AddToCartViewModel {

    let dish: Dish

}

extension AddToCartViewModel {

    var isInCart: Bool {
        guard let cart = CartService.localCart, let dishes = cart.dishes
            else { return false }
        return dishes.contains(where: { $0.id == dish.id })
    }

    var localCartDish: LocalCartDish? {
        guard let cart = CartService.localCart, let dishes = cart.dishes,
            let localCartDish = dishes.first(where: { $0.id == dish.id })
            else { return nil }
        return localCartDish
    }

    var quantityInCart: Int {
        guard let localCartDish = localCartDish
            else { return 0 }
        return localCartDish.quantityInCart
    }

    func canAddToCart() -> Bool {
        guard let localCartDish = localCartDish
            else { return true }
        return localCartDish.canAddToCart()
    }

}
