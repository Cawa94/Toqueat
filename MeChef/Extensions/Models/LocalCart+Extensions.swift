extension LocalCart {

    static let new = LocalCart(dishes: nil,
                               chefId: nil,
                               deliverySlotId: nil,
                               monthday: nil)

    func copyWith(dishes: [LocalCartDish], chefId: Int64? = nil) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliverySlotId: deliverySlotId,
                         monthday: monthday)
    }

    func copyWith(deliverySlotId: Int64) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliverySlotId: deliverySlotId,
                         monthday: monthday)
    }

}
