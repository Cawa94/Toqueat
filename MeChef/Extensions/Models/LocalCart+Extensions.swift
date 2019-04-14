import Foundation

extension LocalCart {

    static let new = LocalCart(dishes: nil,
                               chef: nil,
                               deliveryDate: nil)

    func copyWith(dishes: [LocalCartDish], chef: BaseChef? = nil) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chef: chef,
                         deliveryDate: deliveryDate)
    }

    func copyWith(deliveryDate: Date) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chef: chef,
                         deliveryDate: deliveryDate)
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
