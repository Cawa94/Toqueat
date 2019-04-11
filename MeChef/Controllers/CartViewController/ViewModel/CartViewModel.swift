struct CartViewModel {

    var cart: LocalCart? = CartService.localCart

}

extension CartViewModel {

    var elements: [LocalCartDish] {
        return cart?.dishes ?? []
    }

    func elementAt(_ index: Int) -> LocalCartDish {
        return elements[index]
    }

    var chef: BaseChef? {
        return cart?.chef
    }

}
