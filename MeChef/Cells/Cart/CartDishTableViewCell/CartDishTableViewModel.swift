struct CartDishTableViewModel {

    let dish: LocalCartDish
    let quantityInOrder: Int?
    let isInCart: Bool

    init(dish: LocalCartDish,
         quantityInOrder: Int?,
         isInCart: Bool = true) {
        self.dish = dish
        self.quantityInOrder = quantityInOrder
        self.isInCart = isInCart
    }

}
