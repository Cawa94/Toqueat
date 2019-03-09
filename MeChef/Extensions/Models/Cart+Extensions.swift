extension Cart {

    func copyWith(products: [BaseResultWithIdAndName]) -> Cart? {
        guard let cart = CartService.localCart
            else { return nil }
        return Cart(id: cart.id,
                    userId: cart.userId,
                    products: cart.products,
                    deliverySlot: cart.deliverySlot)
    }

}
