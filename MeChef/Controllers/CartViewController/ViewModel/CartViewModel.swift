struct CartViewModel {

    let cart: LocalCart

}

extension CartViewModel {

    var elements: [LocalCartDish] {
        return cart.dishes ?? []
    }

    func elementAt(_ index: Int) -> LocalCartDish {
        return elements[index]
    }

}
