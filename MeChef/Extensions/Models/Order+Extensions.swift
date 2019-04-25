import Foundation

extension Order {

    var orderState: OrderState {
        return OrderState.getStateFrom(state)
    }

}
