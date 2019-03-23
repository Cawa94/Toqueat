import Foundation

extension Order {

    var orderState: OrderStates {
        return OrderStates.getStateFrom(state)
    }

}
