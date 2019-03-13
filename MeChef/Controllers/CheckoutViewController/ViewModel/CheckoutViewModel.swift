import Foundation

final class CheckoutViewModel: BaseStatefulViewModel<Order> {

    var deliverySlot: DeliverySlot?

    init(userId: Int64) {
        let orderRequest = NetworkService.shared.getOrderWith(orderId: userId)
        super.init(dataSource: orderRequest)
    }

}
