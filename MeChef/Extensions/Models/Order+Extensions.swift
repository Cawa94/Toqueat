import Foundation

extension BaseOrder {

    var orderState: OrderState {
        return OrderState.getStateFrom(state)
    }

}
