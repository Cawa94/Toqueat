extension Order {

    func copyWith(products: [BaseResultWithIdAndName]) -> Order? {
        guard let cart = CartService.localCart
            else { return nil }
        return Order(id: cart.id,
                     userId: cart.userId,
                     products: cart.products,
                     deliverySlot: cart.deliverySlot)
    }

}
