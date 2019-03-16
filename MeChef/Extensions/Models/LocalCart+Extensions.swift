extension LocalCart {

    static let new = LocalCart(dishes: nil,
                               chefId: nil,
                               deliverySlotId: nil)

    func copyWith(dishes: [LocalCartDish], chefId: Int64? = nil) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliverySlotId: deliverySlotId)
    }

    func copyWith(deliverySlotId: Int64) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliverySlotId: deliverySlotId)
    }

}
