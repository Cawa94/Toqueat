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

}
