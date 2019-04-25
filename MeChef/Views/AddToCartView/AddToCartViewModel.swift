struct AddToCartViewModel {

    let dish: Dish

}

extension AddToCartViewModel {

    var isInCart: Bool {
        guard let cart = CartService.localCart, let dishes = cart.dishes
            else { return false }
        return dishes.contains(where: { $0.id == dish.id })
    }

    var quantityInCart: Int {
        guard let cart = CartService.localCart, let dishes = cart.dishes
            else { return 0 }
        return dishes.filter { $0.id == dish.id }.count
    }

}
