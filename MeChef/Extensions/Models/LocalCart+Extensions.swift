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

    var orderVolume: Int {
        guard let dishes = dishes
            else { return 0 }
        return dishes.compactMap({ $0.containerVolume }).reduce(0, +)
    }

    var minContainer: StuartContainer? {
        guard let dishes = dishes
            else { return .medium }
        let biggerContainer = dishes
            .compactMap { StuartContainer.getContainerFrom($0.minContainerSize) }
            .sorted(by: { $0.volume < $1.volume })
            .last ?? nil
        return biggerContainer
    }

    func canAddToCart(_ dishId: Int64) -> Bool {
        if let localCartDish = dishes?.first(where: { $0.id == dishId }) {
            return localCartDish.canAddToCart()
        } else {
            return true
        }
    }

}
