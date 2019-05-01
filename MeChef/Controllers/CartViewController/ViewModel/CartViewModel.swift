struct CartViewModel {

    var cart: LocalCart? = CartService.localCart

}

extension CartViewModel {

    var hasContent: Bool {
        return elements.isNotEmpty
    }

    var elements: [LocalCartDish] {
        return cart?.dishes?.uniqueElements.sorted(by: { $0.name < $1.name }) ?? []
    }

    func elementAt(_ index: Int) -> LocalCartDish {
        return elements[index]
    }

    var chef: BaseChef? {
        return cart?.chef
    }

}
