import Foundation

extension LocalCart {

    static let new = LocalCart(dishes: nil,
                               chef: nil,
                               deliveryDate: nil,
                               deliverySlotId: nil)

    func copyWith(dishes: [LocalCartDish], chef: BaseChef? = nil) -> LocalCart? {
        var cartChef = self.chef
        if let newChef = chef {
            cartChef = newChef
        }
        return LocalCart(dishes: dishes,
                         chef: cartChef,
                         deliveryDate: deliveryDate,
                         deliverySlotId: deliverySlotId)
    }

    func copyWith(deliveryDate: Date, deliverySlotId: Int64) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chef: chef,
                         deliveryDate: deliveryDate,
                         deliverySlotId: deliverySlotId)
    }

    var total: NSDecimalNumber {
        guard let dishes = dishes
            else { return 0.00 }
        return dishes.compactMap({ $0.price }).reduce(0, +)
    }

}

extension NSDecimalNumber {

    static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }

}
