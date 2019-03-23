import Foundation

extension LocalCart {

    static let new = LocalCart(dishes: nil,
                               chefId: nil,
                               deliveryDate: nil)

    func copyWith(dishes: [LocalCartDish], chefId: Int64? = nil) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliveryDate: deliveryDate)
    }

    func copyWith(deliveryDate: Date) -> LocalCart? {
        return LocalCart(dishes: dishes,
                         chefId: chefId,
                         deliveryDate: deliveryDate)
    }

}
